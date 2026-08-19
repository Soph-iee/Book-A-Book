import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../data/sample_books.dart';
import '../widgets/book_card.dart';

/// The full browse list behind "View all".
///
/// TODO(backend): becomes a `ConsumerWidget` again:
///   - `ref.watch(booksControllerProvider)` inside an `AsyncValueView`, which
///     already renders the loading, error and empty branches, with
///     `EmptyStateView` for "no books nearby";
///   - a `RefreshIndicator` calling
///     `ref.read(booksControllerProvider.notifier).refresh()`, which re-fetches
///     *without* flipping to a loading state so the current list stays on
///     screen;
///   - `ref.listen(booksControllerProvider, ...)` for the error SnackBar.
class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = sampleBooks;

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
      body: GridView.builder(
        padding: EdgeInsets.all(Insets.md),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Insets.md,
          mainAxisSpacing: Insets.md,
          // A fixed extent rather than an aspect ratio: the cover inside the
          // card is a fixed 190.h whatever the cell's width, so the card's
          // height does not scale with it.
          mainAxisExtent: 360.h,
        ),
        itemCount: books.length,
        itemBuilder: (context, i) {
          final entry = books[i];
          return BookCard(
            book: entry.book,
            ownerLocation: entry.ownerLocation,
            ownerRating: null,
            // null ⇒ fill the grid cell rather than hold the carousel's 150.
            width: null,
            onTap: () => context.go(AppRoute.bookDetailPath(entry.book.id)),
          );
        },
      ),
    );
  }
}
