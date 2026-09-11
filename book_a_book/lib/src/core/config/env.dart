abstract final class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  static void assertConfigured() {
    if (isConfigured) return;
    throw StateError(
      'Supabase is not configured.\n'
      'Run the app with:\n'
      'flutter run --dart-define-from-file=dart_define.json\n'
      'See dart_define.example.json for the expected shape.',
    );
  }
}
