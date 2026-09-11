import 'dart:async';

import 'package:book_a_book/src/core/router/invalid_book_route.dart';
import 'package:book_a_book/src/core/router/router_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/books/presentation/screens/book_detail_screen.dart';
import '../../features/books/presentation/screens/books_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/location_gate_screen.dart';
import '../supabase/supabase_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoute.home.path,

    refreshListenable: refresh,
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
        path: AppRoute.locationGate.path,
        name: AppRoute.locationGate.name,
        builder: (_, state) {
          final name = state.extra as String? ?? 'there';
          return LocationGateScreen(profileName: name);
        },
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
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) return const InvalidBookRoute();
          return BookDetailScreen(bookId: id);
        },
      ),
    ],
  );
});

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Ref ref) {
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
