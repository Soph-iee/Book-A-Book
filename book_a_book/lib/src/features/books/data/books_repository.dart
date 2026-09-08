import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/supabase/supabase_adapter.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/supabase/tables.dart';
import '../domain/book.dart';
import 'models/book_api_model.dart';

/// All book data access. Nothing above this layer knows Supabase exists.
///
/// Every method returns domain types ([Book]), never `Map<String, dynamic>` —
/// that is what stops PostgREST's shape leaking into your widgets.
class BooksRepository {
  const BooksRepository(this._db);

  final SupabaseAdapter _db;

  /// Embedded select. Because `books.owner_id` has exactly one foreign key to
  /// `profile`, PostgREST can resolve `owner:profile(...)` without a hint.
  /// Tables with two FKs to the same table (like `book_requests`) need the
  /// explicit constraint name instead.
  static const String _withOwner =
      '*, owner:${Tables.profile}(id, name, avatar_url, location_text)';

  // ---------------------------------------------------------------- read

  Future<List<Book>> fetchAvailable({int limit = 20, int offset = 0}) {
    return _db.run(() async {
      final rows = await _db
          .from(Tables.books)
          .select(_withOwner)
          .eq('status', BookStatus.available.dbValue)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return rows.map((row) => BookApiModel.fromMap(row).toDomain()).toList();
    });
  }

  Future<Book> fetchById(int id) {
    return _db.run(() async {
      // `.single()` throws PGRST116 when there is no row, which the adapter
      // maps to NotFoundFailure.
      final row = await _db
          .from(Tables.books)
          .select(_withOwner)
          .eq('id', id)
          .single();

      return BookApiModel.fromMap(row).toDomain();
    });
  }

  Future<List<Book>> fetchByOwner(int ownerId) {
    return _db.run(() async {
      final rows = await _db
          .from(Tables.books)
          .select(_withOwner)
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      return rows.map((row) => BookApiModel.fromMap(row).toDomain()).toList();
    });
  }

  /// Distinct, non-null genres across available books.
  Future<List<String>> fetchAvailableGenres() {
    return _db.run(() async {
      final rows = await _db
          .from(Tables.books)
          .select('genre')
          .eq('status', BookStatus.available.dbValue)
          .not('genre', 'is', null);

      return rows
          .map((row) => row['genre'] as String)
          .toSet()
          .toList()
        ..sort();
    });
  }

  /// Case-insensitive search across title and author.
  ///
  /// `.or()` takes a PostgREST filter string, and commas separate its terms —
  /// so a comma in user input would corrupt the filter. Strip them.
  Future<List<Book>> search(String query, {int limit = 20}) {
    final term = query.trim().replaceAll(',', ' ');
    if (term.isEmpty) return fetchAvailable(limit: limit);

    return _db.run(() async {
      final rows = await _db
          .from(Tables.books)
          .select(_withOwner)
          .or('title.ilike.%$term%,author.ilike.%$term%')
          .limit(limit);

      return rows.map((row) => BookApiModel.fromMap(row).toDomain()).toList();
    });
  }

  /// Realtime feed of available books.
  ///
  /// Caveat worth knowing: `.stream()` talks to the realtime socket, not
  /// PostgREST, so it cannot do embedded joins — `owner` will always be null
  /// here. Use [fetchAvailable] when you need the owner's name.
  Stream<List<BookApiModel>> watchAvailable() {
    return _db
        .stream(Tables.books)
        .eq('status', BookStatus.available.dbValue)
        .order('created_at')
        .map((rows) => rows.map(BookApiModel.fromMap).toList())
        .handleError((Object error) => throw Failure.from(error));
  }

  // --------------------------------------------------------------- write

  /// `.select().single()` after an insert returns the created row, so you get
  /// the database-generated `id` and `created_at` back in one round trip.
  Future<Book> create(Book book) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.books)
          .insert(book.toInsert())
          .select(_withOwner)
          .single();

      return BookApiModel.fromMap(row).toDomain();
    });
  }

  Future<Book> update(int id, Map<String, dynamic> changes) {
    return _db.run(() async {
      final row = await _db
          .from(Tables.books)
          .update(changes)
          .eq('id', id)
          .select(_withOwner)
          .single();

      return BookApiModel.fromMap(row).toDomain();
    });
  }

  Future<void> delete(int id) {
    return _db.run(() async {
      await _db.from(Tables.books).delete().eq('id', id);
    });
  }

  /// Borrowing must check availability, create a request and flip the book's
  /// status atomically — three statements that cannot be three HTTP calls, or
  /// two users race and both "borrow" the same copy.
  ///
  /// So this is the one operation that is real SQL, living in
  /// `supabase/migrations/` as a `plpgsql` function and invoked by name.
  Future<void> borrow(int bookId) {
    return _db.rpc<void>(Rpcs.borrowBook, params: {'p_book_id': bookId});
  }
}

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepository(ref.watch(supabaseAdapterProvider));
});
