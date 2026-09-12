import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.heroTitle.copyWith(color: AppColors.ink),
        ),
        Insets.xs.verticalSpace,
        Text(
          book.author,
          style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
        ),
        Insets.md.verticalSpace,
        Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            DetailChip(label: book.status.label, filled: book.isAvailable),
            DetailChip(label: book.condition.label),
            if (book.genre != null && book.genre!.isNotEmpty)
              DetailChip(label: book.genre!),
          ],
        ),
      ],
    );
  }
}

class DetailChip extends StatelessWidget {
  const DetailChip({
    super.key,
    required this.label,
    this.filled = false,
    this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: filled ? AppColors.brandGreen : AppColors.cream,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: AppTextStyle.statLabel.copyWith(
          color: filled ? AppColors.white : AppColors.ink,
        ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
