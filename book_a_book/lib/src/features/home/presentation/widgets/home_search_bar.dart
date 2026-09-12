import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// Tappable search field. The widget itself is a [StatelessWidget] — it owns
/// no controller, so a screen-level search state stays in the screen, not
/// here. Tapping the bar fires [onTap] so the parent can push a search route
/// or open an inline results sheet.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.onTap, this.onFilterTap});

  final VoidCallback onTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: Material(
        color: AppColors.white,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.md,
              vertical: Insets.sm,
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20.w, color: AppColors.inkFaint),
                Insets.sm.horizontalSpace,
                Expanded(
                  child: Text(
                    'Search by title, author or genre',
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
                if (onFilterTap != null)
                  GestureDetector(
                    onTap: onFilterTap,
                    child: Padding(
                      padding: EdgeInsets.only(left: Insets.sm),
                      child: Icon(
                        Icons.filter_list,
                        size: 20.w,
                        color: AppColors.brandGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
