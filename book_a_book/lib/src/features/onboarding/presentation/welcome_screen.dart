import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OnboardingBrandMark(),
        Insets.lg.verticalSpace,
        const OnboardingIllustration(
          image: 'assets/images/step-1.jpg',
          height: 210,
          label: 'Open book illustration',
        ),
        Insets.xl.verticalSpace,
        const OnboardingTitle('A good book might be\ncloser than you think.'),
        Insets.reg.verticalSpace,
        const OnboardingBody(
          'BookaBook connects you with  readers nearby, so more stories can find their next reader.',
        ),
        Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swipe, size: 20.w, color: AppColors.surfaceTint),
            Insets.xs.horizontalSpace,
            Text(
              'Swipe to continue, or tap below',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Insets.sm.verticalSpace,
        PrimaryButton(
          label: 'Choose your genres',
          icon: Icons.arrow_forward,
          expand: true,
          onPressed: () => context.go('/onboarding/genres'),
        ),
        Insets.xl.verticalSpace,
        // TextLinkButton(
        //   label: 'I already have an account',
        //   onPressed: () => context.go('/sign-in'),
        // ),
      ],
    );
  }
}
