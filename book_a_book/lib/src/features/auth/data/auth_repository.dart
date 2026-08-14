import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';

/// All authentication data access.
///
/// `supabase_flutter` already persists the session to disk and refreshes the
/// token in the background, so there is no token handling to write here — a
/// large part of what the Go backend used to do is simply gone.
class AuthRepository {
  const AuthRepository(this._db);

  final SupabaseAdapter _db;

  Session? get currentSession => _db.auth.currentSession;

  User? get currentUser => _db.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _db.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _db.run(
      () => _db.auth.signInWithPassword(email: email, password: password),
    );
  }

  /// Anything passed as `data` lands in `auth.users.raw_user_meta_data`, which
  /// a Postgres trigger can read to create the matching `profiles` row. That
  /// trigger belongs in a migration — do not try to insert the profile from
  /// the client, because the row must exist before the client is trusted.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return _db.run(
      () => _db.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      ),
    );
  }

  Future<void> signOut() => _db.run(() => _db.auth.signOut());

  Future<void> sendPasswordReset(String email) {
    return _db.run(() => _db.auth.resetPasswordForEmail(email));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseAdapterProvider));
});
