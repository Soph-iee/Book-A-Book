import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingLocationPreview extends StatelessWidget {
  const OnboardingLocationPreview({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 145.h,
    decoration: BoxDecoration(
      color: AppColors.onboardingGreen,
      borderRadius: AppRadius.mdAll,
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.map_outlined,
          size: 90.w,
          color: AppColors.brandGreen.withValues(alpha: 0.2),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Insets.sm),
              decoration: const BoxDecoration(
                color: AppColors.brandGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on, color: AppColors.white),
            ),
            Insets.xs.verticalSpace,
            Text(
              'Your neighbourhood',
              style: AppTextStyle.featureTitle.copyWith(
                color: AppColors.brandGreen,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
