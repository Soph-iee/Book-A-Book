import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenreChoiceTile extends StatelessWidget {
  const GenreChoiceTile({
    super.key,
    required this.name,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$name, ${selected ? 'selected' : 'not selected'}',
    child: InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: Container(
        padding: EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.onboardingGreen : AppColors.white,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: selected ? AppColors.brandGreen : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 26.w,
                backgroundColor: selected
                    ? AppColors.white
                    : AppColors.onboardingGreen,
                child: Icon(icon, color: AppColors.brandGreen, size: 24.w),
              ),
            ),
            if (selected)
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.check_circle, color: AppColors.brandGreen),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.tileLabel.copyWith(color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
