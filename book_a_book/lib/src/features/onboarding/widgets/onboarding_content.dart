import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingBrandMark extends StatelessWidget {
  const OnboardingBrandMark({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Book-A-Book logo',
    child: Container(
      width: 88.w,
      height: 88.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.lgAll,
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.brandGreen,
        size: 42,
      ),
    ),
  );
}

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.image,
    required this.height,
    required this.label,
  });

  final String image;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    image: true,
    child: Container(
      width: double.infinity,
      height: height.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Image.asset(image, fit: BoxFit.cover),
    ),
  );
}

class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: AppTextStyle.heroTitle.copyWith(
      fontSize: 32.sp,
      color: AppColors.brandGreen,
    ),
  );
}

class OnboardingBody extends StatelessWidget {
  const OnboardingBody(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: AppTextStyle.heroBody.copyWith(color: AppColors.inkMuted),
  );
}
