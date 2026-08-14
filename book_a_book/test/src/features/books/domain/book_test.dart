import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter_test/flutter_test.dart';

/// `fromMap` is the boundary against Postgres, so it is the highest-value thing
/// in the codebase to test: a schema change breaks here first, loudly, instead
/// of as a null somewhere in the widget tree.
void main() {
  group('Book.fromMap', () {
    test('maps snake_case columns onto camelCase fields', () {
      final book = Book.fromMap({
        'id': 7,
        'owner_id': 1,
        'title': 'Atomic Habits',
        'author': 'James Clear',
        'isbn': '9780735211292',
        'cover_image_url': ['https://example.com/l.jpg'],
        'condition': 'good',
        'status': 'borrowed',
        'genre': 'Self-Help',
        'why_read': 'Habit stacking.',
        'tags': ['habits', 'productivity'],
        'created_at': '2026-04-22T17:41:00Z',
      });

      expect(book.id, 7);
      expect(book.title, 'Atomic Habits');
      expect(book.coverImageUrls, hasLength(1));
      expect(book.condition, BookCondition.good);
      expect(book.status, BookStatus.borrowed);
      expect(book.tags, ['habits', 'productivity']);
      expect(book.createdAt, isNotNull);
      expect(book.isAvailable, isFalse);
    });

    test('parses a raw Postgres array literal', () {
      final book = Book.fromMap({
        'id': 1,
        'owner_id': 1,
        'title': 'T',
        'author': 'A',
        'tags': '{"sci-fi","space"}',
      });

      expect(book.tags, ['sci-fi', 'space']);
    });

    test('falls back rather than throwing on an unknown enum value', () {
      final book = Book.fromMap({
        'id': 1,
        'owner_id': 1,
        'title': 'T',
        'author': 'A',
        'condition': 'pristine', // not a value we know
      });

      expect(book.condition, BookCondition.good);
    });

    test('reads the embedded owner when the query selected one', () {
      final book = Book.fromMap({
        'id': 1,
        'owner_id': 3,
        'title': 'T',
        'author': 'A',
        'owner': {'id': 3, 'name': 'Amara Okafor', 'avatar_url': null},
      });

      expect(book.owner?.name, 'Amara Okafor');
    });

    test('leaves owner null when the query did not select one', () {
      final book = Book.fromMap({
        'id': 1,
        'owner_id': 3,
        'title': 'T',
        'author': 'A',
      });

      expect(book.owner, isNull);
    });
  });
}
