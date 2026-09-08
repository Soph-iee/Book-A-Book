/// Domain representation of an auth session.
///
/// Plain Dart — no Supabase dependency. The data layer converts the SDK
/// (Software Development Kit) values before constructing this.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.expiresAt,
  });

  final String accessToken;
  final DateTime expiresAt;
}
