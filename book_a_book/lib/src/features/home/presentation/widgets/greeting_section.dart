import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// "Good afternoon, Amara" + a location chip.
///
/// Time-of-day greeting is computed in the widget so the parent does not have
/// to thread the current hour through. The location is a plain string — the
/// parent is responsible for resolving it from the profile or a hard default.
class GreetingSection extends StatelessWidget {
  const GreetingSection({
    super.key,
    required this.name,
    required this.location,
    this.onLocationTap,
  });

  final String name;
  final String location;
  final VoidCallback? onLocationTap;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting(),
            style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
          ),
          Insets.xs.verticalSpace,
          Row(
            children: [
              Flexible(
                child: Text(
                  name,
                  style: AppTextStyle.sectionTitle.copyWith(
                    color: AppColors.brandGreen,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Insets.sm.horizontalSpace,
              _LocationChip(label: location, onTap: onLocationTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.pillAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14.w,
              color: AppColors.brandGreen,
            ),
            Insets.xs.horizontalSpace,
            Flexible(
              child: Text(
                label,
                style: AppTextStyle.statLabel.copyWith(color: AppColors.ink),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 14.w, color: AppColors.ink),
          ],
        ),
      ),
    );
  }
}
