import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// The type scale, on Poppins.
///
/// **Every entry is a getter, never a `const`.** `.sp` is a runtime getter on
/// `num` that reads the initialised `ScreenUtil` instance, so it cannot appear
/// in a const expression. A `const` token file is the single most common way
/// ScreenUtil goes wrong: it silently keeps unscaled values while the rest of
/// the UI scales, and the layout drifts apart on tablets.
///
/// **No style here carries a colour.** Colour is applied at the call site with
/// `.copyWith(color:)`, because the same style appears in both inks —
/// `sectionTitle` is `ink` on the page but `white` in the footer, and
/// `statLabel` is `inkMuted` for *escrow* but `brandGreen` for *borrow period*.
/// Baking a colour in would force a near-duplicate token for each pairing.
abstract final class AppTextStyle {
  static TextStyle _p(
    double size,
    FontWeight weight, {
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.poppins(
    fontSize: size.sp,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
  );

  // --- Hero
  static TextStyle get heroTitle => _p(28, FontWeight.w700, height: 1.2);
  static TextStyle get heroBody => _p(15, FontWeight.w400, height: 1.5);
  static TextStyle get pillLabel => _p(12, FontWeight.w600, letterSpacing: 0.5);

  // --- Sections
  static TextStyle get sectionTitle => _p(18, FontWeight.w700);
  static TextStyle get viewAll => _p(14, FontWeight.w500);

  // --- Feature badges
  static TextStyle get featureTitle => _p(14, FontWeight.w600);
  static TextStyle get featureSub => _p(12, FontWeight.w400);

  // --- Category tiles
  static TextStyle get tileLabel => _p(13, FontWeight.w600);

  // --- Book cards
  static TextStyle get cardTitle => _p(15, FontWeight.w600);
  static TextStyle get cardAuthor => _p(13, FontWeight.w400);
  static TextStyle get ownerName => _p(12, FontWeight.w500);
  static TextStyle get statValue => _p(14, FontWeight.w700);
  static TextStyle get statLabel => _p(11, FontWeight.w400);
  static TextStyle get badgeLabel => _p(11, FontWeight.w600);

  // --- How it works
  static TextStyle get stepTitle => _p(12, FontWeight.w600);
  static TextStyle get stepBody => _p(11, FontWeight.w400, height: 1.4);

  // --- CTA banner
  static TextStyle get bannerTitle => _p(16, FontWeight.w700);
  static TextStyle get bannerBody => _p(13, FontWeight.w400);

  // --- Chrome
  static TextStyle get buttonLabel => _p(15, FontWeight.w600);
  static TextStyle get footerLink => _p(13, FontWeight.w500);
  static TextStyle get wordmark => _p(20, FontWeight.w700);

  // --- Prose and forms
  static TextStyle get body => _p(14, FontWeight.w400, height: 1.5);
  static TextStyle get label => _p(13, FontWeight.w500);
}
