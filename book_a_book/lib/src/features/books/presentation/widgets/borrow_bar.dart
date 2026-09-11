import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/buttons.dart';
import '../widgets/escrow_stat.dart';

class BorrowBar extends StatelessWidget {
  const BorrowBar({super.key, this.book});

  final Book? book;

  (String label, bool enabled) get _cta => switch (book!.status) {
    BookStatus.available => ('Borrow this book', true),
    BookStatus.requested => ('Requested', false),
    BookStatus.borrowed => ('Currently borrowed', false),
  };

  @override
  Widget build(BuildContext context) {
    if (book == null) return const SizedBox.shrink();

    final (label, enabled) = _cta;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.md),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const EscrowStat(
                      value: EscrowStat.placeholder,
                      label: 'escrow',
                    ),
                    Insets.md.horizontalSpace,
                    const Flexible(
                      child: EscrowStat(
                        value: EscrowStat.placeholder,
                        label: 'borrow period',
                        accent: true,
                      ),
                    ),
                  ],
                ),
              ),
              Insets.md.horizontalSpace,
              PrimaryButton(
                label: label,
                onPressed: enabled ? () => _confirmBorrow(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBorrow(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Borrow this book?',
                style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
              ),
              Insets.sm.verticalSpace,
              Text(
                book!.title,
                style: AppTextStyle.cardTitle.copyWith(
                  color: AppColors.brandGreen,
                ),
              ),
              Insets.md.verticalSpace,
              Row(
                children: [
                  const EscrowStat(
                    value: EscrowStat.placeholder,
                    label: 'escrow',
                  ),
                  Insets.xl.horizontalSpace,
                  const EscrowStat(
                    value: EscrowStat.placeholder,
                    label: 'borrow period',
                    accent: true,
                  ),
                ],
              ),
              Insets.md.verticalSpace,
              Text(
                'Your escrow is refundable when you return the book in good '
                'condition.',
                style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
              ),
              Insets.lg.verticalSpace,
              PrimaryButton(
                label: 'Confirm and pay escrow',
                expand: true,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Borrowing is not wired up yet.'),
                    ),
                  );
                },
              ),
              Insets.sm.verticalSpace,
              SecondaryButton(
                label: 'Cancel',
                expand: true,
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
