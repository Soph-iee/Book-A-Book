import 'package:book_a_book/src/core/widgets/async_value_view.dart';
import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:book_a_book/src/features/books/presentation/view_models/books_view_model.dart';
import 'package:book_a_book/src/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/router_enum.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/buttons.dart';

class AvailableSection extends ConsumerWidget {
  const AvailableSection({super.key, required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooks = ref.watch(booksViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Available near you',
                  style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
                ),
              ),
              TextLinkButton(label: 'See all', onPressed: onViewAll),
            ],
          ),
        ),
        Insets.sm.verticalSpace,
        SizedBox(
          height: 260.h,
          child: AsyncValueView<List<Book>>(
            value: asyncBooks,
            onRetry: () => ref.invalidate(booksViewModelProvider),
            builder: (books) {
              if (books.isEmpty) {
                return const EmptyStateView(
                  message: 'No books available right now.',
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Insets.md),
                itemCount: books.length,
                separatorBuilder: (_, _) => Insets.md.horizontalSpace,
                itemBuilder: (context, i) {
                  final entry = books[i];
                  return BookCard(
                    book: entry,
                    ownerLocation: entry.owner?.locationText,
                    ownerRating: null,
                    onTap: () => context.go(AppRoute.bookDetailPath(entry.id)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
