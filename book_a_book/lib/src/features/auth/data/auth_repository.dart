import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../domain/auth_session.dart';
import '../domain/auth_user.dart';

/// All authentication data access.
///
/// `supabase_flutter` already persists the session to disk and refreshes the
/// token in the background, so there is no token handling to write here — a
/// large part of what the Go backend used to do is simply gone.
class AuthRepository {
  const AuthRepository(this._db);

  final SupabaseAdapter _db;

  AuthSession? get currentSession {
    final session = _db.auth.currentSession;
    if (session == null) return null;
    return AuthSession(
      accessToken: session.accessToken,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
        isUtc: true,
      ),
    );
  }

  AuthUser? get currentUser {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
    );
  }

  Stream<AuthState> get onAuthStateChange => _db.auth.onAuthStateChange;

  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) {
    return _db.run(
      () async {
        final response = await _db.auth.signInWithPassword(
          email: email,
          password: password,
        );
        final user = response.user;
        if (user == null) {
          throw const AuthException('Sign-in failed: no user returned.');
        }
        return AuthUser(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] as String?,
        );
      },
    );
  }

  /// Anything passed as `data` lands in `auth.users.raw_user_meta_data`, which
  /// a Postgres trigger can read to create the matching `profiles` row. That
  /// trigger belongs in a migration — do not try to insert the profile from
  /// the client, because the row must exist before the client is trusted.
  ///
  ///
  static const String kEmailRedirectTo = 'io.supabase.flutterquickstart://login-callback';

  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String name,
    String? redirectTo = kEmailRedirectTo,
  }) {
    return _db.run(
      () async {
        final response = await _db.auth.signUp(
          email: email,
          password: password,
          data: {'name': name},
          emailRedirectTo: redirectTo ?? kEmailRedirectTo,
        );
        final user = response.user;
        if (user == null) {
          throw const AuthException('Sign-up failed: no user returned.');
        }
        return AuthUser(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] as String?,
        );
      },
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
