import '../../books/domain/book.dart';

/// A borrow request. Mirrors the `book_requests` table.
class BookRequest {
  const BookRequest({
    required this.id,
    required this.bookId,
    required this.borrowerId,
    required this.ownerId,
    this.status = RequestStatus.pending,
    this.createdAt,
    this.book,
  });

  final int id;
  final int bookId;
  final int borrowerId;
  final int ownerId;
  final RequestStatus status;
  final DateTime? createdAt;

  /// Populated only when the query embedded `books(...)`.
  final Book? book;

  bool get isOpen => status.isOpen;

  factory BookRequest.fromMap(Map<String, dynamic> map) {
    return BookRequest(
      id: map['id'] as int,
      bookId: map['book_id'] as int,
      borrowerId: map['borrower_id'] as int,
      ownerId: map['owner_id'] as int,
      status: RequestStatus.fromDb(map['status']),
      createdAt: map['created_at'] is String
          ? DateTime.tryParse(map['created_at'] as String)?.toLocal()
          : null,
      book: map['book'] is Map<String, dynamic>
          ? Book.fromMap(map['book'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toInsert() => {
        'book_id': bookId,
        'borrower_id': borrowerId,
        'owner_id': ownerId,
        'status': status.dbValue,
      };
}

enum RequestStatus {
  pending('pending', 'Pending'),
  approved('approved', 'Approved'),
  declined('declined', 'Declined'),
  borrowed('borrowed', 'Borrowed'),
  returned('returned', 'Returned'),
  cancelled('cancelled', 'Cancelled');

  const RequestStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  /// Still needs someone to act on it.
  bool get isOpen => this == pending || this == approved || this == borrowed;

  static RequestStatus fromDb(Object? value) => RequestStatus.values.firstWhere(
        (s) => s.dbValue == value,
        orElse: () => RequestStatus.pending,
      );
}
