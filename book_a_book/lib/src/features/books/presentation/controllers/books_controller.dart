import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/books_repository.dart';
import '../../domain/book.dart';

/// Owns the *UI state* of the book list — loading, error, data — and nothing
/// else. It never touches Supabase; it delegates to [BooksRepository].
///
/// That split is the point: the repository answers "how do I get books", the
/// controller answers "what should the screen show right now".
class BooksController extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() {
    // `watch` (not `read`) so that if the repository provider is ever
    // invalidated — e.g. on sign-out — this list rebuilds automatically.
    return ref.watch(booksRepositoryProvider).fetchAvailable();
  }

  BooksRepository get _repository => ref.read(booksRepositoryProvider);

  /// Re-fetches without flipping to a loading state, so the current list stays
  /// on screen while the request is in flight. `RefreshIndicator` draws its own
  /// spinner, so a second one would only cause a flash of empty content.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_repository.fetchAvailable);
  }

  /// [AsyncValue.guard] is the idiom to internalise: it runs the callback and
  /// captures success into `AsyncData` or a thrown [Failure] into `AsyncError`,
  /// so you never write try/catch in a controller.
  Future<void> borrow(int bookId) async {
    state = await AsyncValue.guard(() async {
      await _repository.borrow(bookId);
      return _repository.fetchAvailable();
    });
  }

  Future<void> delete(int bookId) async {
    // Optimistic update: drop it locally first so the list feels instant, then
    // reconcile with the server.
    final previous = state.value ?? const <Book>[];
    state = AsyncValue.data(
      previous.where((book) => book.id != bookId).toList(),
    );

    state = await AsyncValue.guard(() async {
      await _repository.delete(bookId);
      return _repository.fetchAvailable();
    });
  }
}

final booksControllerProvider =
    AsyncNotifierProvider<BooksController, List<Book>>(BooksController.new);

/// Search results, keyed by query string.
///
/// `.family` builds one provider per argument; `.autoDispose` throws each away
/// when nothing is listening, so typing five characters does not leak five
/// cached result sets forever.
final bookSearchProvider = FutureProvider.autoDispose
    .family<List<Book>, String>((ref, query) {
      return ref.watch(booksRepositoryProvider).search(query);
    });

/// A single book, for the detail screen.
final bookByIdProvider = FutureProvider.autoDispose.family<Book, int>((
  ref,
  id,
) {
  return ref.watch(booksRepositoryProvider).fetchById(id);
});

/// Distinct genres across available books.
final availableGenresProvider = FutureProvider.autoDispose<List<String>>((ref) {
  return ref.watch(booksRepositoryProvider).fetchAvailableGenres();
});
