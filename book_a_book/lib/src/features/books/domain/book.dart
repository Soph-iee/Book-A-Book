/// Domain model for a book.
///
/// This is hand-mapped on purpose. `fromMap` is the boundary between Postgres'
/// `snake_case` columns and Dart's `camelCase` fields, and it is the one place
/// a schema change should ever break the app.
class Book {
  const Book({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    this.isbn,
    this.coverImageUrls = const [],
    this.condition = BookCondition.good,
    this.status = BookStatus.available,
    this.aiSummary,
    this.genre,
    this.whyRead,
    this.tags = const [],
    this.createdAt,
    this.owner,
  });

  final int id;
  final int ownerId;
  final String title;
  final String author;
  final String? isbn;

  /// Postgres `text[]`. Largest resolution first, by convention in the seed.
  final List<String> coverImageUrls;

  final BookCondition condition;
  final BookStatus status;
  final String? aiSummary;
  final String? genre;
  final String? whyRead;
  final List<String> tags;
  final DateTime? createdAt;

  /// Populated only when the query asked for the embedded join
  /// (`select('*, owner:profiles(...)')`). Null otherwise.
  final BookOwner? owner;

  String? get primaryCoverUrl =>
      coverImageUrls.isEmpty ? null : coverImageUrls.first;

  bool get isAvailable => status == BookStatus.available;

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      ownerId: map['owner_id'] as int,
      title: map['title'] as String? ?? 'Untitled',
      author: map['author'] as String? ?? 'Unknown author',
      isbn: map['isbn'] as String?,
      coverImageUrls: _stringList(map['cover_image_url']),
      condition: BookCondition.fromDb(map['condition']),
      status: BookStatus.fromDb(map['status']),
      aiSummary: map['ai_summary'] as String?,
      genre: map['genre'] as String?,
      whyRead: map['why_read'] as String?,
      tags: _stringList(map['tags']),
      createdAt: _dateTime(map['created_at']),
      owner: map['owner'] is Map<String, dynamic>
          ? BookOwner.fromMap(map['owner'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Only the columns the client is allowed to write. `id`, `created_at` and
  /// anything the database computes are deliberately absent — let Postgres own
  /// them.
  Map<String, dynamic> toInsert() => {
    'owner_id': ownerId,
    'title': title,
    'author': author,
    'isbn': isbn,
    'cover_image_url': coverImageUrls,
    'condition': condition.dbValue,
    'status': status.dbValue,
    'genre': genre,
    'why_read': whyRead,
    'tags': tags,
  };

  Book copyWith({
    String? title,
    String? author,
    String? isbn,
    List<String>? coverImageUrls,
    BookCondition? condition,
    BookStatus? status,
    String? genre,
    String? whyRead,
    List<String>? tags,
  }) {
    return Book(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      coverImageUrls: coverImageUrls ?? this.coverImageUrls,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      aiSummary: aiSummary,
      genre: genre ?? this.genre,
      whyRead: whyRead ?? this.whyRead,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      owner: owner,
    );
  }

  /// PostgREST returns `text[]` as a JSON array, but be defensive: a raw
  /// Postgres array literal (`{"a","b"}`) can still arrive from an RPC.
  static List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList(growable: false);
    }
    if (value is String && value.startsWith('{') && value.endsWith('}')) {
      final inner = value.substring(1, value.length - 1);
      if (inner.isEmpty) return const [];
      return inner
          .split(',')
          .map((e) => e.trim().replaceAll('"', ''))
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  static DateTime? _dateTime(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Book && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// A lightweight slice of `profiles`, embedded in book queries.
///
/// Deliberately *not* the full `Profile` model: keeping it local means the
/// books feature does not import the profile feature, so the two stay
/// independently changeable.
class BookOwner {
  const BookOwner({required this.id, required this.name, this.avatarUrl});

  final int id;
  final String name;
  final String? avatarUrl;

  factory BookOwner.fromMap(Map<String, dynamic> map) => BookOwner(
    id: map['id'] as int,
    name: map['name'] as String? ?? 'Unknown',
    avatarUrl: map['avatar_url'] as String?,
  );
}

/// Mirrors the `condition` enum in Postgres.
enum BookCondition {
  likeNew('like_new', 'Like new'),
  good('good', 'Good'),
  fair('fair', 'Fair'),
  poor('poor', 'Poor');

  const BookCondition(this.dbValue, this.label);

  /// The exact string stored in the database.
  final String dbValue;

  /// What a human reads.
  final String label;

  static BookCondition fromDb(Object? value) => BookCondition.values.firstWhere(
    (c) => c.dbValue == value,
    orElse: () => BookCondition.good,
  );
}

/// Mirrors the `status` enum in Postgres.
enum BookStatus {
  available('available', 'Available'),
  requested('requested', 'Requested'),
  borrowed('borrowed', 'Borrowed');

  const BookStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static BookStatus fromDb(Object? value) => BookStatus.values.firstWhere(
    (s) => s.dbValue == value,
    orElse: () => BookStatus.available,
  );
}
