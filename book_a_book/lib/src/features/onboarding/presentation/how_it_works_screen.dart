import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:book_a_book/src/features/onboarding/widgets/how_it_works_widgets.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_content.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextLinkButton(
            label: 'Skip',
            onPressed: () => context.go('/onboarding/location'),
          ),
        ),
        const OnboardingIllustration(
          image: 'assets/images/step-2.jpg',
          height: 210,
          label: 'Readers sharing books illustration',
        ),
        Insets.lg.verticalSpace,
        const OnboardingTitle('Share stories.\nKeep reading.'),
        Insets.sm.verticalSpace,
        const OnboardingBody(
          'A simple local loop helps books keep moving from one reader to the next.',
        ),
        Insets.lg.verticalSpace,
        const OnboardingStepsPanel(),
        Insets.md.verticalSpace,
        const OnboardingTrustNote(),
        Insets.lg.verticalSpace,
        const OnboardingProgressDots(step: 3),
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: 'How it works',
          icon: Icons.arrow_forward,
          expand: true,
          onPressed: () => context.go('/onboarding/location'),
        ),
      ],
    );
  }
}
