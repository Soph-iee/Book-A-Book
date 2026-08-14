import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// A backend-agnostic error type.
///
/// Nothing above the `data/` layer should ever see a [PostgrestException] or an
/// [AuthException]. The adapter translates every Supabase error into one of
/// these so that controllers and widgets can switch on a stable, sealed set.
///
/// Being `sealed` means the compiler forces you to handle every case in a
/// `switch` — add a subclass and every exhaustive switch becomes a compile
/// error until you handle it.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Safe to show to a user.
  final String message;

  /// Classifies any thrown object into a [Failure].
  factory Failure.from(Object error) {
    return switch (error) {
      final Failure f => f,
      final PostgrestException e => _fromPostgrest(e),
      final AuthException e => AuthFailure(e.message),
      final StorageException e => StorageFailure(e.message),
      TimeoutException() => const NetworkFailure('The request timed out.'),
      _ when _looksLikeNetwork(error) => const NetworkFailure(),
      _ => UnknownFailure(error.toString()),
    };
  }

  static Failure _fromPostgrest(PostgrestException e) {
    // PostgREST surfaces RLS denials as 42501, and `.single()` misses as PGRST116.
    return switch (e.code) {
      'PGRST116' => const NotFoundFailure(),
      '42501' => const PermissionFailure(),
      '23505' => const DatabaseFailure('That record already exists.'),
      '23503' => const DatabaseFailure('That record is still referenced.'),
      _ => DatabaseFailure(e.message),
    };
  }

  // Deliberately string-based: `dart:io` cannot be imported on web, so we
  // cannot catch `SocketException` by type in cross-platform code.
  static bool _looksLikeNetwork(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('connection refused') ||
        text.contains('clientexception');
  }

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure([
    super.message = 'You do not have permission to do that.',
  ]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found.']);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
