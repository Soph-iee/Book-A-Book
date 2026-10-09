import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:book_a_book/src/features/onboarding/presentation/location_onboarding_screen.dart';
import 'package:book_a_book/src/features/onboarding/widgets/genre_choice_tile.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_content.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GenreSelectionScreen extends ConsumerWidget {
  const GenreSelectionScreen({super.key});

  static const genres = <({String name, IconData icon})>[
    (name: 'Fiction', icon: Icons.auto_stories_outlined),
    (name: 'African Literature', icon: Icons.public),
    (name: 'Romance', icon: Icons.favorite_border),
    (name: 'Self Help', icon: Icons.psychology_outlined),
    (name: 'Business', icon: Icons.trending_up),
    (name: 'Faith & Spirit', icon: Icons.auto_awesome_outlined),
    (name: 'Mystery', icon: Icons.fingerprint),
    (name: 'Biography', icon: Icons.face_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider);
    return Column(
      children: [
        const OnboardingTitle('What are you in the\nmood to read?'),
        Insets.sm.verticalSpace,
        const OnboardingBody(
          'Pick a few genres and we’ll help your next great read find you.',
        ),
        Insets.lg.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: Insets.md),
          itemCount: genres.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 210.w,
            mainAxisExtent: 120.h,
            crossAxisSpacing: Insets.md,
            mainAxisSpacing: Insets.md,
          ),
          itemBuilder: (context, index) {
            final genre = genres[index];
            return GenreChoiceTile(
              name: genre.name,
              icon: genre.icon,
              selected: controller.selectedGenres.contains(genre.name),
              onTap: () => ref
                  .read(onboardingControllerProvider)
                  .toggleGenre(genre.name),
            );
          },
        ),
        Text(
          '${controller.selectedGenres.length} selected',
          style: AppTextStyle.statLabel.copyWith(color: AppColors.inkMuted),
        ),
        Insets.sm.verticalSpace,
        PrimaryButton(
          label: 'Continue',
          icon: Icons.arrow_forward,
          expand: true,
          onPressed: () => context.go('/onboarding/how-it-works'),
        ),
        TextLinkButton(
          label: 'I’ll choose later',
          onPressed: () => context.go('/onboarding/how-it-works'),
        ),
      ],
    );
  }
}
