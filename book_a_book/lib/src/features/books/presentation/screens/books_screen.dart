import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../domain/book.dart';
import '../view_models/books_view_model.dart';
import '../widgets/book_card.dart';

/// The full browse list behind "View all".
class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooks = ref.watch(booksViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Available books'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.w, color: AppColors.ink),
          tooltip: 'Back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoute.home.path),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(booksViewModelProvider.notifier).refresh(),
        child: AsyncValueView<List<Book>>(
          value: asyncBooks,
          onRetry: () => ref.invalidate(booksViewModelProvider),
          builder: (books) {
            if (books.isEmpty) {
              return const EmptyStateView(
                message: 'No books available right now.',
              );
            }
            return GridView.builder(
              padding: EdgeInsets.all(Insets.md),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Insets.md,
                mainAxisSpacing: Insets.md,
                mainAxisExtent: 360.h,
              ),
              itemCount: books.length,
              itemBuilder: (context, i) {
                final book = books[i];
                return BookCard(
                  book: book,
                  ownerRating: null,
                  width: null,
                  onTap: () => context.go(AppRoute.bookDetailPath(book.id)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
