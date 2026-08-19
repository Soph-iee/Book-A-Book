import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_text_style.dart';
import 'color.dart';

/// Spacing scale.
///
/// These are getters, not `static const double`, because `.w` reads the
/// initialised `ScreenUtil` instance at call time. The cost is that
/// `EdgeInsets.all(Insets.md)` can no longer be `const`, so
/// `prefer_const_constructors` stops firing on those call sites. That is the
/// correct trade: an unscaled layout is a real bug, a missing `const` on an
/// `EdgeInsets` is not.
abstract final class Insets {
  static double get xs => 4.w;
  static double get sm => 8.w;

  /// The page margin.
  static double get md => 16.w;
  static double get lg => 24.w;

  /// The gap between page sections.
  static double get xl => 32.w;
}

/// Corner radii, scaled on the smaller axis with `.r`.
abstract final class AppRadius {
  /// Book cover images.
  static double get sm => 8.r;

  /// Cards, category tiles, buttons, inputs, step cards.
  static double get md => 12.r;

  /// The "How it works" panel and the CTA banner.
  static double get lg => 16.r;

  /// The tagline pill, location badges, chips.
  static double get pill => 999.r;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get pillAll => BorderRadius.circular(pill);
}

abstract final class AppTheme {
  /// The scheme is built explicitly rather than with [ColorScheme.fromSeed].
  ///
  /// `fromSeed` runs the Material tonal-palette algorithm, which will *not*
  /// return `#3A6D44` for a surface you asked to be `#3A6D44` — it produces
  /// harmonised tones. The design specifies flat literal colours, so the
  /// algorithm is the wrong tool here.
  static const ColorScheme _scheme = ColorScheme.light(
    primary: AppColors.brandGreen,
    onPrimary: AppColors.onGreen,
    secondary: AppColors.brandGreen,
    onSecondary: AppColors.onGreen,
    surface: AppColors.white,
    onSurface: AppColors.ink,

    /// The hero and "How it works" panel fill.
    surfaceContainerLow: AppColors.cream,
    surfaceContainerHighest: AppColors.cream,
    outlineVariant: AppColors.cardBorder,
  );

  static ThemeData light() {
    return ThemeData(
      colorScheme: _scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,

      // Maps the Material slots existing screens already read onto the scale,
      // so untouched widgets pick up Poppins without being rewritten.
      textTheme: _textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.ink,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyle.sectionTitle.copyWith(
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: AppTextStyle.body.copyWith(color: AppColors.inkFaint),
        errorStyle: AppTextStyle.statLabel.copyWith(color: _scheme.error),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
        border: _inputBorder(BorderSide.none),
        enabledBorder: _inputBorder(
          BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
        focusedBorder: _inputBorder(
          BorderSide(color: AppColors.brandGreen, width: 1.5.w),
        ),
        errorBorder: _inputBorder(BorderSide(color: _scheme.error, width: 1.w)),
        focusedErrorBorder: _inputBorder(
          BorderSide(color: _scheme.error, width: 1.5.w),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandGreen,
          foregroundColor: AppColors.onGreen,
          minimumSize: Size.fromHeight(44.h),
          textStyle: AppTextStyle.buttonLabel,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: AppTextStyle.body.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
    );
  }

  /// The mockup is light-only.
  ///
  /// Returning [light] means a device in dark mode gets one correct theme
  /// rather than a half-guessed second one, and it keeps the seam in place for
  /// when a dark palette is actually designed.
  static ThemeData dark() => light();

  static OutlineInputBorder _inputBorder(BorderSide side) =>
      OutlineInputBorder(borderRadius: AppRadius.mdAll, borderSide: side);

  static TextTheme get _textTheme => TextTheme(
    headlineSmall: AppTextStyle.heroTitle,
    titleLarge: AppTextStyle.sectionTitle,
    titleMedium: AppTextStyle.cardTitle,
    titleSmall: AppTextStyle.featureTitle,
    bodyLarge: AppTextStyle.heroBody,
    bodyMedium: AppTextStyle.body,
    bodySmall: AppTextStyle.cardAuthor,
    labelLarge: AppTextStyle.buttonLabel,
    labelMedium: AppTextStyle.label,
    labelSmall: AppTextStyle.statLabel,
  );
}
