import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

/// Drives sign-in / sign-up / sign-out.
///
/// The state is `void` because this controller produces no data — the screen
/// only cares whether the last action is in flight ([AsyncValue.isLoading]) or
/// failed ([AsyncValue.hasError]). The *session* itself lives in
/// `currentSessionProvider`, fed by Supabase's own auth stream.
class AuthController extends AsyncNotifier<void> {
  @override
  void build() {
    // Nothing to load: this controller is command-only.
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signIn(email: email, password: password),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signUp(email: email, password: password, name: name),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.signOut);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
