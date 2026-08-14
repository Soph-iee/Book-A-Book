import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_adapter.dart';

/// The adapter every repository depends on.
///
/// Overriding this one provider in a `ProviderScope` swaps the entire backend
/// out — that is the whole payoff of routing access through a single seam:
///
/// ```dart
/// ProviderScope(
///   overrides: [supabaseAdapterProvider.overrideWithValue(FakeAdapter())],
///   child: const BookABookApp(),
/// )
/// ```
final supabaseAdapterProvider = Provider<SupabaseAdapter>((ref) {
  return SupabaseAdapter(Supabase.instance.client);
});

/// Emits on sign-in, sign-out, and token refresh.
///
/// The router listens to this to decide whether to redirect to `/sign-in`.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseAdapterProvider).auth.onAuthStateChange;
});

/// The current session, or `null` when signed out.
///
/// Derived synchronously from [authStateChangesProvider] so widgets can read it
/// without handling a loading state on every rebuild.
final currentSessionProvider = Provider<Session?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value?.session ??
      ref.watch(supabaseAdapterProvider).auth.currentSession;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentSessionProvider)?.user.id;
});
