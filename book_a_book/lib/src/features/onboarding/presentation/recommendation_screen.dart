import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:book_a_book/src/features/onboarding/presentation/location_onboarding_screen.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(onboardingControllerProvider);
    final genre = state.selectedGenres.isEmpty
        ? 'your reading list'
        : state.selectedGenres.first;
    final location = state.locationLabel ?? state.manualArea ?? 'your area';
    return Column(
      children: [
        const OnboardingIllustration(
          image:
              'assets/images/pngtree-5-hardbooks-sitting-on-each-other-with-quotes-png-image_18725745-removebg-preview 1.png',
          height: 210,
          label: 'Book discovery illustration',
        ),
        Insets.lg.verticalSpace,
        const OnboardingTitle('Your next\nchapter starts\nhere.'),
        Insets.sm.verticalSpace,

        const OnboardingBody(
          'We found books and readers that fit your interests nearby. Ready to explore?',
        ),
        Insets.lg.verticalSpace,
        Semantics(
          button: true,
          label: 'Recommendations based on $genre near $location',
          child: Container(
            padding: EdgeInsets.all(Insets.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.onboardingGreen,
                  child: const Icon(
                    Icons.favorite_border,
                    color: AppColors.brandGreen,
                  ),
                ),
                Insets.md.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Because you love $genre',
                        style: AppTextStyle.featureTitle,
                      ),
                      Text(
                        'Books near $location',
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.brandGreen),
              ],
            ),
          ),
        ),
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: 'Explore books',
          icon: Icons.arrow_forward,
          expand: true,
          onPressed: () => context.go('/books'),
        ),
        TextLinkButton(
          label: 'Set up my profile',
          onPressed: () => context.go('/'),
        ),
      ],
    );
  }
}
