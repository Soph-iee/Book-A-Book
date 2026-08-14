import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/supabase/tables.dart';
import '../domain/book_request.dart';

class RequestsRepository {
  const RequestsRepository(this._db);

  final SupabaseAdapter _db;

  /// `book_requests` has **two** foreign keys to `profiles` (`borrower_id` and
  /// `owner_id`), so PostgREST cannot guess which one you mean — an ambiguous
  /// `profiles(...)` here returns a PGRST201 error. You must name the
  /// constraint explicitly with `!constraint_name`.
  ///
  /// Verify these names against your schema:
  ///   select conname from pg_constraint where conrelid = 'book_requests'::regclass;
  static const String _withRelations = '''
*,
book:${Tables.books}(id, title, author, cover_image_url, status),
borrower:${Tables.profiles}!book_requests_borrower_id_fkey(id, name, avatar_url),
owner:${Tables.profiles}!book_requests_owner_id_fkey(id, name, avatar_url)
''';

  /// Requests this user has made.
  Future<List<BookRequest>> fetchOutgoing(int profileId) {
    return _db.run(() async {
      final rows = await _db
          .from(Tables.bookRequests)
          .select(_withRelations)
          .eq('borrower_id', profileId)
          .order('created_at', ascending: false);

      return rows.map(BookRequest.fromMap).toList();
    });
  }

  /// Requests other people have made for this user's books.
  Future<List<BookRequest>> fetchIncoming(int profileId) {
    return _db.run(() async {
      final rows = await _db
          .from(Tables.bookRequests)
          .select(_withRelations)
          .eq('owner_id', profileId)
          .order('created_at', ascending: false);

      return rows.map(BookRequest.fromMap).toList();
    });
  }

  Future<BookRequest> updateStatus(int requestId, RequestStatus status) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.bookRequests)
          .update({'status': status.dbValue})
          .eq('id', requestId)
          .select(_withRelations)
          .single();

      return BookRequest.fromMap(row);
    });
  }

  Future<void> cancel(int requestId) =>
      updateStatus(requestId, RequestStatus.cancelled);
}

final requestsRepositoryProvider = Provider<RequestsRepository>((ref) {
  return RequestsRepository(ref.watch(supabaseAdapterProvider));
});
