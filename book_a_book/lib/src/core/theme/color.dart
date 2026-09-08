import 'package:flutter/material.dart';

/// The palette, sampled from `assets/images/iPhone 14 & 15 Pro - 1.png`.
///
/// Five tokens is the whole design. Resist adding a sixth: the greys that look
/// like tokens in the mockup (`#404040`, `#7B766D`, `#B9B2A4`, `#DFDFDF`…) are
/// antialiasing between one of these and a background, not design decisions.
///
/// Colours never scale, so unlike [AppTextStyle] these stay `const`.
abstract final class AppColors {
  // --- Sampled from the mockup.
  static const Color brandGreen = Color(0xFF3A6D44);
  static const Color cream = Color(0xFFF7EDDB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF000000);
  static const Color star = Color(0xFFF29D38);

  // --- Derived. Not sampled — computed from the five above, so the one place
  // to change the brand is still `brandGreen`.
  static const Color onGreen = white;

  /// The 1px hairline around a book card.
  ///
  /// Cream, not grey: scanning the mockup across a card's left edge gives
  /// `#FFFFFF … #F7EDDB(1px) … #FFFFFF`. It reads as a soft shadow but it is a
  /// stroke, and drawing it grey makes the cards look colder than the design.
  static const Color cardBorder = cream;

  /// Secondary text.
  ///
  /// A deliberate addition: the mockup renders captions in pure black, which
  /// works at its tiny type sizes but gives no hierarchy at real ones.
  static Color get inkMuted => ink.withValues(alpha: 0.60);
  static Color get inkFaint => ink.withValues(alpha: 0.40);

  static Color get greenPressed => brandGreen.withValues(alpha: 0.85);
  static Color get greenDisabled => brandGreen.withValues(alpha: 0.38);

  /// Behind app-bar controls that sit over a book cover.
  static Color get scrim => ink.withValues(alpha: 0.45);

  /// The footer copyright, which sits on `brandGreen`.
  static Color get whiteMuted => white.withValues(alpha: 0.70);
    static const Color surface = Color(0xFFf8faf4);
  static const Color surfaceDim = Color(0xFFd8dbd5);
  static const Color surfaceBright = Color(0xFFf8faf4);
  static const Color surfaceContainerLowest = Color(0xFFffffff);
  static const Color surfaceContainerLow = Color(0xFFf2f4ef);
  static const Color surfaceContainer = Color(0xFFecefe9);
  static const Color surfaceContainerHigh = Color(0xFFe7e9e3);
  static const Color surfaceContainerHighest = Color(0xFFe1e3de);
  static const Color onSurface = Color(0xFF191c19);
  static const Color onSurfaceVariant = Color(0xFF414941);
  static const Color inverseSurface = Color(0xFF2e312e);
  static const Color inverseOnSurface = Color(0xFFeff1ec);
  static const Color outline = Color(0xFF717970);
  static const Color outlineVariant = Color(0xFFc0c9bf);
  static const Color surfaceTint = Color(0xFF316943);
  static const Color primary = Color(0xFF14502c);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color primaryContainer = Color(0xFF2f6842);
  static const Color onPrimaryContainer = Color(0xFFa7e5b5);
  static const Color inversePrimary = Color(0xFF98d4a6);
  static const Color secondary = Color(0xFF625e54);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color secondaryContainer = Color(0xFFe8e2d5);
  static const Color onSecondaryContainer = Color(0xFF68645a);
  static const Color tertiary = Color(0xFF3e483a);
  static const Color onTertiary = Color(0xFFffffff);
  static const Color tertiaryContainer = Color(0xFF556051);
  static const Color onTertiaryContainer = Color(0xFFcedac7);
  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFffffff);
  static const Color errorContainer = Color(0xFFffdad6);
  static const Color onErrorContainer = Color(0xFF93000a);
  static const Color primaryFixed = Color(0xFFb3f1c0);
  static const Color primaryFixedDim = Color(0xFF98d4a6);
  static const Color onPrimaryFixed = Color(0xFF00210d);
  static const Color onPrimaryFixedVariant = Color(0xFF16512d);
  static const Color secondaryFixed = Color(0xFFe8e2d5);
  static const Color secondaryFixedDim = Color(0xFFccc6ba);
  static const Color onSecondaryFixed = Color(0xFF1e1b14);
  static const Color onSecondaryFixedVariant = Color(0xFF4a463d);
  static const Color tertiaryFixed = Color(0xFFdae6d3);
  static const Color tertiaryFixedDim = Color(0xFFbecab8);
  static const Color onTertiaryFixed = Color(0xFF141e12);
  static const Color onTertiaryFixedVariant = Color(0xFF3f4a3c);
  static const Color background = Color(0xFFf8faf4);
  static const Color onBackground = Color(0xFF191c19);
  static const Color surfaceVariant = Color(0xFFe1e3de);
}

