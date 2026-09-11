import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/cover_app_bar.dart';
import 'owner_card.dart';
import 'prose_section.dart';
import 'tags_section.dart';
import 'title_block.dart';

class BookDetailBody extends StatelessWidget {
  const BookDetailBody({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CoverAppBar(book: book),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleBlock(book: book),
                Insets.lg.verticalSpace,
                if (book.owner != null) ...[
                  OwnerCard(owner: book.owner!),
                  Insets.lg.verticalSpace,
                ],
                if (book.aiSummary != null) ...[
                  ProseSection(
                    heading: 'About this book',
                    body: book.aiSummary!,
                    aiGenerated: true,
                  ),
                  Insets.lg.verticalSpace,
                ],
                if (book.whyRead != null) ...[
                  ProseSection(
                    heading: 'Why read it',
                    body: book.whyRead!,
                    aiGenerated: true,
                  ),
                  Insets.lg.verticalSpace,
                ],
                if (book.tags.isNotEmpty) TagsSection(tags: book.tags),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
