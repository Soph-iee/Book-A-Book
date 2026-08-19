import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/books/presentation/screens/book_detail_screen.dart';
import '../../features/books/presentation/screens/books_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../errors/failure.dart';
import '../supabase/supabase_providers.dart';
import '../widgets/async_value_view.dart';

/// Route names and paths in one enum, so no screen ever hardcodes `'/books'`
/// and a path rename is a single edit.
enum AppRoute {
  home('/'),
  signIn('/sign-in'),
  signUp('/sign-up'),
  books('/books'),
  bookDetail('/books/:id');

  const AppRoute(this.path);

  final String path;

  /// Fills in the `:id` parameter of [AppRoute.bookDetail].
  static String bookDetailPath(int id) => '/books/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoute.home.path,

    // Without this, `redirect` only runs on navigation — so signing out while
    // sitting on a screen would leave the user there, looking at stale data.
    refreshListenable: refresh,

    // TODO(backend): re-add the auth gate, inverted.
    //
    // The old gate was "signed out ⇒ go to /sign-in", which makes a public
    // landing page unreachable. It becomes "signed out AND the target is a
    // protected route ⇒ go to /sign-in":
    //
    //   redirect: (context, state) {
    //     final isSignedIn = ref.read(supabaseAdapterProvider).isSignedIn;
    //     const protected = <String>{'/list-a-book'};
    //     if (!isSignedIn && protected.contains(state.matchedLocation)) {
    //       return AppRoute.signIn.path;
    //     }
    //     return null;
    //   },
    //
    // None of the routes below are protected: the auth wall moves down to the
    // *actions* — borrowing and listing a book. Signed-out users browsing
    // freely is the entire point of a landing page.
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        builder: (_, _) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        name: AppRoute.signUp.name,
        builder: (_, _) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoute.books.path,
        name: AppRoute.books.name,
        builder: (_, _) => const BooksScreen(),
      ),
      GoRoute(
        path: AppRoute.bookDetail.path,
        name: AppRoute.bookDetail.name,
        builder: (_, state) {
          // Parse here rather than in the screen: a FormatException escaping
          // into the widget tree is a red screen, not a 404.
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) return const _InvalidBookRoute();
          return BookDetailScreen(bookId: id);
        },
      ),
    ],
  );
});

class _InvalidBookRoute extends StatelessWidget {
  const _InvalidBookRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // AppErrorView only renders the message of a [Failure]; anything else
      // falls back to a generic string. So hand it one.
      body: const AppErrorView(
        error: NotFoundFailure('That book link is not valid.'),
      ),
    );
  }
}

/// Bridges Supabase's auth [Stream] to the [Listenable] go_router expects.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    final adapter = ref.read(supabaseAdapterProvider);
    _subscription = adapter.auth.onAuthStateChange.listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
