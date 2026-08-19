import '../domain/book.dart';

/// ---------------------------------------------------------------------------
/// PLACEHOLDER DATA — delete this file when the backend is wired.
/// ---------------------------------------------------------------------------
///
/// The screens are built UI-first, so they read from this list instead of from
/// [BooksRepository]. Every call site that reads it carries a `TODO(backend)`
/// naming the provider that replaces it, so wiring is a find-and-replace on one
/// string rather than a hunt.
///
/// [ownerLocation] lives here rather than on [Book] on purpose. Books have no
/// location column; the value belongs to the owner's `Profile.locationText`,
/// and `BooksRepository._withOwner` does not select it today. Pairing it
/// alongside the book keeps that join visible instead of pretending `Book`
/// carries something it does not.
typedef SampleBook = ({Book book, String? ownerLocation});

/// Cover art is served by Open Library, keyed by ISBN. When the device is
/// offline these fail and [BookCover] draws its cream fallback — which is the
/// path worth seeing during a design review anyway.
String _cover(String isbn) =>
    'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg';

final List<SampleBook> sampleBooks = [
  (
    book: Book(
      id: 1,
      ownerId: 11,
      title: 'Making It Big',
      author: 'Femi Otedola',
      genre: 'Business',
      condition: BookCondition.good,
      aiSummary:
          'A first-person account of building — and nearly losing — one of '
          'Nigeria\'s largest business empires, told through the deals that '
          'made it and the ones that almost ended it.',
      whyRead:
          'Rare candour about failure from someone with no obligation to be '
          'candid about it.',
      tags: const ['business', 'memoir', 'nigeria'],
      owner: const BookOwner(id: 11, name: 'Damilola Soyinka'),
    ),
    ownerLocation: 'Bodija',
  ),
  (
    book: Book(
      id: 2,
      ownerId: 12,
      title: 'Atomic Habits',
      author: 'James Clear',
      isbn: '9780735211292',
      coverImageUrls: [_cover('9780735211292')],
      genre: 'Self Help',
      condition: BookCondition.likeNew,
      aiSummary:
          'Argues that outcomes are lagging indicators of habits, and that the '
          'leverage is in redesigning the system rather than summoning more '
          'willpower.',
      whyRead: 'The four-law framework is short enough to actually apply.',
      tags: const ['habits', 'productivity', 'psychology'],
      owner: const BookOwner(id: 12, name: 'Tunde Adeyemi'),
    ),
    ownerLocation: 'Yaba',
  ),
  (
    book: Book(
      id: 3,
      ownerId: 13,
      title: 'Things Fall Apart',
      author: 'Chinua Achebe',
      isbn: '9780385474542',
      coverImageUrls: [_cover('9780385474542')],
      genre: 'Fiction',
      condition: BookCondition.fair,
      aiSummary:
          'Okonkwo\'s rise and ruin in Umuofia, set against the arrival of '
          'colonial administration and the mission church.',
      tags: const ['classic', 'fiction', 'nigeria'],
      owner: const BookOwner(id: 13, name: 'Ngozi Eze'),
    ),
    ownerLocation: 'Agbowo',
  ),
  (
    book: Book(
      id: 4,
      ownerId: 14,
      title: 'Purple Hibiscus',
      author: 'Chimamanda Ngozi Adichie',
      isbn: '9781616202415',
      coverImageUrls: [_cover('9781616202415')],
      genre: 'Fiction',
      condition: BookCondition.good,
      status: BookStatus.requested,
      whyRead: 'A quiet book about a loud house.',
      tags: const ['fiction', 'coming-of-age'],
      owner: const BookOwner(id: 14, name: 'Ifeoma A.'),
    ),
    ownerLocation: 'Bodija',
  ),
  (
    book: Book(
      id: 5,
      ownerId: 15,
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      isbn: '9780593135204',
      coverImageUrls: [_cover('9780593135204')],
      genre: 'Fiction',
      condition: BookCondition.likeNew,
      status: BookStatus.borrowed,
      aiSummary:
          'A lone astronaut wakes with amnesia aboard a ship he did not agree '
          'to board, tasked with stopping an extinction he cannot remember.',
      tags: const ['science fiction', 'space'],
      owner: const BookOwner(id: 15, name: 'Kelechi O.'),
    ),
    ownerLocation: 'Yaba',
  ),
  (
    book: Book(
      id: 6,
      ownerId: 16,
      title: 'The Purpose Driven Life',
      author: 'Rick Warren',
      isbn: '9780310205715',
      coverImageUrls: [_cover('9780310205715')],
      genre: 'Religious',
      condition: BookCondition.good,
      tags: const ['faith', 'devotional'],
      owner: const BookOwner(id: 16, name: 'Grace Bello'),
    ),
    ownerLocation: 'Agbowo',
  ),
];

SampleBook? sampleBookById(int id) {
  for (final entry in sampleBooks) {
    if (entry.book.id == id) return entry;
  }
  return null;
}
