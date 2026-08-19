/// Form rules shared by both auth screens.
///
/// **These validate the trimmed value but the screens submit the raw one.**
/// `AuthController` already calls `email.trim()` and `name.trim()` before
/// handing them to the repository; trimming again in the widget duplicates a
/// rule that lives in the controller, and the two will eventually disagree.
abstract final class AuthValidators {
  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your name';
    if (text.length < 2) return 'That seems too short';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email';

    final at = text.indexOf('@');
    final dot = text.indexOf('.', at + 1);
    if (at <= 0 || dot < 0 || dot == text.length - 1) {
      return 'That does not look like an email';
    }
    return null;
  }

  /// Six characters is Supabase's own default minimum. Matching it means the
  /// client rejects what the server would reject anyway, rather than inventing
  /// a stricter rule the backend does not enforce.
  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Please enter a password';
    if (text.length < 6) return 'At least 6 characters';
    return null;
  }
}
