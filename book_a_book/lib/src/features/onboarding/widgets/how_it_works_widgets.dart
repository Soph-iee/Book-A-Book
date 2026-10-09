import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingStepsPanel extends StatelessWidget {
  const OnboardingStepsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        'Find a book near you.',
        'Discover local readers and their libraries.',
        Icons.search,
      ),
      (
        'Request and meet safely.',
        'Arrange a convenient public handover.',
        Icons.handshake_outlined,
      ),
      (
        'Read, return, repeat.',
        'Enjoy the story and pass it on.',
        Icons.autorenew,
      ),
    ];
    return Container(
      padding: EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final item = steps[index];
          return Semantics(
            label: '${item.$1} ${item.$2}',
            child: Padding(
              padding: EdgeInsets.only(
                bottom: index == steps.length - 1 ? 0 : Insets.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.$3, color: AppColors.brandGreen, size: 28.w),
                  Insets.md.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1, style: AppTextStyle.featureTitle),
                        Text(
                          item.$2,
                          style: AppTextStyle.body.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OnboardingTrustNote extends StatelessWidget {
  const OnboardingTrustNote({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Insets.md),
    decoration: BoxDecoration(
      color: AppColors.onboardingGreen,
      borderRadius: AppRadius.mdAll,
      border: Border.all(color: AppColors.brandGreen),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.shield_outlined, color: AppColors.brandGreen),
        8.horizontalSpace,
        Expanded(
          child: Text(
            'Trust note: Your deposit is returned when the book comes back in the agreed condition.',
            style: AppTextStyle.body.copyWith(color: AppColors.brandGreen),
          ),
        ),
      ],
    ),
  );
}
