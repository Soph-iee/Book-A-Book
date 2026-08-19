import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';

enum AppLogoVariant { dark, light }

/// The wordmark. Used in the header (dark on cream) and the footer (white on
/// green), so it needs both inks.
///
/// Mark and wordmark take the *same* colour — the mockup's logo is single-ink
/// in each context.
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
        SizedBox(width: Insets.sm),
        Text(
          'Book-A-Book',
          style: AppTextStyle.wordmark.copyWith(color: color),
        ),
      ],
    );
  }
}
