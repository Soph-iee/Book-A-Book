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
}
