import '../../domain/book.dart';

/// Raw API model that mirrors the PostgREST response shape for a `books` row.
///
/// Keeping this separate from [Book] means the domain model can rename fields,
/// add derived getters, or drop columns without touching the mapper.
class BookApiModel {
  const BookApiModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    this.isbn,
    this.coverImageUrl,
    this.condition,
    this.status,
    this.aiSummary,
    this.genre,
    this.whyRead,
    this.tags,
    this.createdAt,
    this.owner,
  });

  final int id;
  final int ownerId;
  final String title;
  final String author;
  final String? isbn;
  final List<String>? coverImageUrl;
  final String? condition;
  final String? status;
  final String? aiSummary;
  final String? genre;
  final String? whyRead;
  final List<String>? tags;
  final DateTime? createdAt;
  final BookOwnerApiModel? owner;

  factory BookApiModel.fromMap(Map<String, dynamic> map) => BookApiModel(
    id: map['id'] as int,
    ownerId: map['owner_id'] as int,
    title: map['title'] as String? ?? 'Untitled',
    author: map['author'] as String? ?? 'Unknown author',
    isbn: map['isbn'] as String?,
    coverImageUrl: Book.stringList(map['cover_image_url']),
    condition: map['condition'] as String?,
    status: map['status'] as String?,
    aiSummary: map['ai_summary'] as String?,
    genre: map['genre'] as String?,
    whyRead: map['why_read'] as String?,
    tags: Book.stringList(map['tags']),
    createdAt: Book.dateTime(map['created_at']),
    owner: map['owner'] is Map<String, dynamic>
        ? BookOwnerApiModel.fromMap(map['owner'] as Map<String, dynamic>)
        : null,
  );

  Book toDomain() => Book(
    id: id,
    ownerId: ownerId,
    title: title,
    author: author,
    isbn: isbn,
    coverImageUrls: coverImageUrl ?? const [],
    condition: BookCondition.fromDb(condition),
    status: BookStatus.fromDb(status),
    aiSummary: aiSummary,
    genre: genre,
    whyRead: whyRead,
    tags: tags ?? const [],
    createdAt: createdAt,
    owner: owner?.toDomain(),
  );
}

class BookOwnerApiModel {
  const BookOwnerApiModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.locationText,
  });

  final int id;
  final String name;
  final String? avatarUrl;
  final String? locationText;

  factory BookOwnerApiModel.fromMap(Map<String, dynamic> map) =>
      BookOwnerApiModel(
        id: map['id'] as int,
        name: map['name'] as String? ?? 'Unknown',
        avatarUrl: map['avatar_url'] as String?,
        locationText: map['location_text'] as String?,
      );

  BookOwner toDomain() => BookOwner(
    id: id,
    name: name,
    avatarUrl: avatarUrl,
    locationText: locationText,
  );
}
