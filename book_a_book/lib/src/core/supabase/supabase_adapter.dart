import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';

/// The single seam between this application and Supabase.
///
/// Design intent — this is deliberately a *thin* adapter, not a generic
/// repository. An adapter that tried to hide PostgREST behind
/// `select(table, filters)` would reimplement the query builder badly and lose
/// joins, ranges and `.stream()`. Instead it keeps the fluent builder and
/// centralises the three things you genuinely want in one place:
///
///  1. **Error translation** — every call routed through [run] throws a
///     [Failure], never a raw `PostgrestException`.
///  2. **A single injection point** — repositories depend on this type, so a
///     test can hand them a fake without a live network.
///  3. **A boundary you can grep** — `SupabaseClient` should appear in this
///     file and nowhere else in `lib/`.
class SupabaseAdapter {
  const SupabaseAdapter(this._client);

  final SupabaseClient _client;

  /// Entry point for table queries: `adapter.from(Tables.books).select()`.
  SupabaseQueryBuilder from(String table) => _client.from(table);

  GoTrueClient get auth => _client.auth;

  SupabaseStorageClient get storage => _client.storage;

  /// The signed-in user's UUID, or `null` when signed out.
  String? get currentUserId => _client.auth.currentUser?.id;

  bool get isSignedIn => currentUserId != null;

  /// Runs [operation], converting any thrown object into a [Failure].
  ///
  /// [Error.throwWithStackTrace] rethrows with the *original* stack trace, so
  /// crash reports still point at the query that failed rather than at this
  /// line.
  Future<T> run<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure.from(error), stackTrace);
    }
  }

  /// Calls a Postgres function. Use this for logic that must be atomic.
  Future<T> rpc<T>(String function, {Map<String, dynamic>? params}) {
    return run(() => _client.rpc<T>(function, params: params));
  }

  /// A realtime stream of rows. Emits immediately, then on every change.
  ///
  /// Note this bypasses [run]: errors arrive on the stream's error channel, so
  /// they are mapped with [Failure.from] via `handleError` at the call site in
  /// the repository.
  SupabaseStreamFilterBuilder stream(
    String table, {
    List<String> primaryKey = const ['id'],
  }) {
    return _client.from(table).stream(primaryKey: primaryKey);
  }
}
