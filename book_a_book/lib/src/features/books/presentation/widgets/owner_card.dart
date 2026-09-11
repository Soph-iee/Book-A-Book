import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:book_a_book/src/features/books/presentation/widgets/owner_rating_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/buttons.dart';

class OwnerCard extends StatelessWidget {
  const OwnerCard({required this.owner, super.key});

  final BookOwner owner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerRatingRow(
            name: owner.name,
            avatarUrl: owner.avatarUrl,
            rating: null,
            avatarSize: 40,
          ),
          Insets.md.verticalSpace,
          SecondaryButton(
            label: 'View shelf',
            expand: true,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shelves are not wired up yet.')),
            ),
          ),
        ],
      ),
    );
  }
}
