import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// One numbered step in the "How it works" panel.
///
/// The number is part of [title] ("1. Find a book") rather than its own
/// parameter, matching how the mockup writes it.
///
/// The 2px green border was confirmed by scanning the mockup across a step
/// card: `cream ×8 │ #3A6D44 ×2 │ white ×26 │ …icon… │ white ×31 │ #3A6D44 ×2 │
/// cream`.
class HowItWorksStep extends StatelessWidget {
  const HowItWorksStep({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: AppColors.brandGreen, width: 2.w),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 28.w, color: AppColors.brandGreen),
        ),
        Insets.sm.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.stepTitle.copyWith(color: AppColors.ink),
        ),
        Insets.xs.verticalSpace,
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyle.stepBody.copyWith(color: AppColors.inkMuted),
        ),
      ],
    );
  }
}
