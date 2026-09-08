import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';

/// The "BORROW. READ. RETURN. REPEAT." chip in the hero.
///
/// There is deliberately **no border**: scanning the mockup across the pill's
/// left edge gives cream straight into white with no stroke pixel. The edge you
/// see is pure fill contrast, and adding a border makes it heavier than the
/// design.
class TaglinePill extends StatelessWidget {
  const TaglinePill({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16.w, color: AppColors.brandGreen),
            Insets.sm.horizontalSpace,
          ],
          Flexible(
            child: Text(
              label,
              style: AppTextStyle.pillLabel.copyWith(
                color: AppColors.brandGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
