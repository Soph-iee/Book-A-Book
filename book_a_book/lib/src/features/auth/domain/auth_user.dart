/// Domain representation of an authenticated user.
///
/// Plain Dart — no Supabase dependency. The data layer is responsible for
/// constructing this from SDK (Software Development Kit) types.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.name,
  });

  final String id;
  final String email;
  final String? name;
}
