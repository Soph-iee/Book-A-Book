import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// A backend-agnostic error type.
///
/// Sealed so UI code can switch exhaustively when it needs to, but most
/// callers should just read [message] — that string is already safe to
/// show to a user.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Safe to show to a user.
  final String message;

  /// Classifies any thrown object into a [Failure].
  factory Failure.from(Object error) => switch (error) {
    final Failure f => f,
    final AuthException e => AuthFailure(_serverMessage(e), e.statusCode),
    final PostgrestException e => DatabaseFailure(
      _serverMessage(e),
      code: e.code,
      status: e.code,
    ),
    final StorageException e => StorageFailure(_serverMessage(e)),
    TimeoutException() => const NetworkFailure(),
    _ when _looksLikeNetwork(error) => const NetworkFailure(),
    _ => UnknownFailure(error.toString()),
  };

  static String _serverMessage(Object e) {
    // Supabase's exception classes set `.message` from the response body's
    // `message` field (or `error_description` / `error`). When those are
    // absent they fall back to a localized SDK string — still safe to show.
    final raw = (e as dynamic).message as String?;
    return (raw == null || raw.trim().isEmpty) ? 'Something went wrong.' : raw;
  }

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
  const AuthFailure(super.message, this.status);
  final String? status; // 'invalid_credentials', 'user_already_exists', ...
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {this.code, this.status});
  final String? code; // 'PGRST116', '42501', ...
  final String? status; // 400, 409, 422, ...
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Surfaces a friendly message for auth-specific failures.
///
/// Strategy: the server already gives us a localized message in/// `failure.message`. We only override it for codes that are confusing
/// ("Invalid login credentials" is fine; "user_already_exists" is not).
String authFriendlyMessage(Failure failure) {
  if (failure is! AuthFailure) return failure.message;
  return switch (failure.status) {
    'user_already_exists' || 'email_exists' =>
      'An account with this email already exists. Try signing in.',
    'over_email_send_rate_limit' || 'over_request_rate_limit' =>
      'Too many attempts. Please wait a minute and try again.',
    _ => failure.message,
  };
}
