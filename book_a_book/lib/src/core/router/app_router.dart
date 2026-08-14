import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/books/presentation/screens/books_screen.dart';
import '../supabase/supabase_providers.dart';

/// Route names and paths in one enum, so no screen ever hardcodes `'/books'`
/// and a path rename is a single edit.
enum AppRoute {
  signIn('/sign-in'),
  books('/');

  const AppRoute(this.path);

  final String path;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoute.books.path,

    // Without this, `redirect` only runs on navigation — so signing out while
    // sitting on a screen would leave the user there, looking at stale data.
    refreshListenable: refresh,

    /// The single auth gate for the whole app.
    ///
    /// Putting it here rather than in each screen means a new screen is
    /// protected by default: you cannot forget to add a guard you never wrote.
    redirect: (context, state) {
      final isSignedIn = ref.read(supabaseAdapterProvider).isSignedIn;
      final isOnSignIn = state.matchedLocation == AppRoute.signIn.path;

      if (!isSignedIn) return isOnSignIn ? null : AppRoute.signIn.path;
      if (isOnSignIn) return AppRoute.books.path;
      return null; // null means "no redirect, carry on".
    },
    routes: [
      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        builder: (_, _) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoute.books.path,
        name: AppRoute.books.name,
        builder: (_, _) => const BooksScreen(),
      ),
    ],
  );
});

/// Bridges Supabase's auth [Stream] to the [Listenable] go_router expects.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    _subscription = ref
        .read(supabaseAdapterProvider)
        .auth
        .onAuthStateChange
        .listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
