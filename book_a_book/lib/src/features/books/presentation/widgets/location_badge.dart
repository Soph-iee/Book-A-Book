import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// The "Bodija" / "Yaba" / "Agbowo" pill over a book cover.
///
/// The value comes from the *owner's* `Profile.locationText` — `Book` has no
/// location field of its own. It is passed in as a plain string so this widget
/// stays free of the domain layer.
class LocationBadge extends StatelessWidget {
  const LocationBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.brandGreen,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: AppTextStyle.badgeLabel.copyWith(color: AppColors.white),
      ),
    );
  }
}
