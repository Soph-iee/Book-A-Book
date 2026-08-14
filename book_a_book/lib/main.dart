import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/core/config/env.dart';

/// Bootstrap only. Everything else lives under `lib/src/`.
///
/// Keeping `main` this small matters: it is the one place that runs before
/// Flutter is ready, so anything that creeps in here is untestable and runs on
/// every single launch.
Future<void> main() async {
  // Required before any async work that touches platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  // Fail loudly at startup rather than with a confusing 401 on the first query.
  Env.assertConfigured();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  // ProviderScope is where all Riverpod state lives. Nothing above it can read
  // a provider, which is why it wraps the app rather than sitting inside it.
  runApp(const ProviderScope(child: BookABookApp()));
}
