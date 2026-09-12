import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';

enum AppLogoVariant { dark, light }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.variant = AppLogoVariant.dark,
    this.size = 24,
  });

  final AppLogoVariant variant;

  /// Mark size; the wordmark scales from the type token, not from this.
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = variant == AppLogoVariant.dark
        ? AppColors.ink
        : AppColors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.menu_book_rounded, size: size.w, color: color),
        Insets.sm.horizontalSpace,
        Text(
          'Book-A-Book',
          style: AppTextStyle.wordmark.copyWith(color: color),
        ),
      ],
    );
  }
}
