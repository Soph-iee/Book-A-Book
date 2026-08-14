/// Compile-time configuration.
///
/// Values are injected with `--dart-define-from-file=dart_define.json` so that
/// no key is ever committed. `String.fromEnvironment` is a *const* lookup:
/// it is resolved by the compiler, which is why these are `static const` and
/// not read from a `.env` file at runtime.
///
/// A note on which key belongs here. The publishable key (`sb_publishable_...`,
/// formerly called the anon key) is designed to ship inside client apps — it
/// grants no privileges on its own, because Row Level Security decides what
/// each request may do. The **secret** key (formerly `service_role`) bypasses
/// RLS entirely and must never appear in a Flutter build; anyone can unzip an
/// APK. If you need privileged work, put it in an Edge Function.
abstract final class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  /// Fails fast at startup rather than surfacing a confusing 401 on the first
  /// query.
  static void assertConfigured() {
    if (isConfigured) return;
    throw StateError(
      'Supabase is not configured.\n'
      'Run the app with:\n'
      '  flutter run --dart-define-from-file=dart_define.json\n'
      'See dart_define.example.json for the expected shape.',
    );
  }
}
