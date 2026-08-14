/// Table and column names live here so a rename in Postgres is a single edit
/// in Dart, and so typos fail at compile time instead of at runtime.
abstract final class Tables {
  static const String profiles = 'profiles';
  static const String books = 'books';
  static const String bookRequests = 'book_requests';
}

/// Names of Postgres functions invoked through `adapter.rpc(...)`.
///
/// Anything that must be atomic (check availability + insert request + flip
/// status) belongs in a migration as a `plpgsql` function, not in Dart.
abstract final class Rpcs {
  static const String borrowBook = 'borrow_book';
  static const String booksNearby = 'books_nearby';
}

/// Supabase Storage bucket names.
abstract final class Buckets {
  static const String covers = 'covers';
  static const String avatars = 'avatars';
}
