import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/books_controller.dart';
import '../widgets/book_card.dart';

/// The screen's job is layout and wiring: read state, hand it to widgets, send
/// events back to the controller. No data access, no business rules.
class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksControllerProvider);

    // `ref.listen` is for side effects — snackbars, navigation, dialogs.
    // Doing this inside `build` via `ref.watch` would fire on every rebuild.
    ref.listen(booksControllerProvider, (previous, next) {
      final error = next.error;
      if (error == null || next.isLoading) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error is Failure ? error.message : 'Something failed.'),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(booksControllerProvider.notifier).refresh(),
        child: AsyncValueView(
          value: booksState,
          onRetry: () => ref.invalidate(booksControllerProvider),
          builder: (books) {
            if (books.isEmpty) {
              return const EmptyStateView(
                message: 'No books are available right now.',
                icon: Icons.menu_book_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(Insets.md),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(height: Insets.md),
              itemBuilder: (context, index) {
                final book = books[index];

                return BookCard(
                  book: book,
                  onBorrow: () => ref
                      .read(booksControllerProvider.notifier)
                      .borrow(book.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
