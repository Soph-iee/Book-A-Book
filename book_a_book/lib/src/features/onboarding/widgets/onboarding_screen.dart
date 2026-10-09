import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/features/onboarding/presentation/genre_selection_screen.dart';
import 'package:book_a_book/src/features/onboarding/presentation/how_it_works_screen.dart';
import 'package:book_a_book/src/features/onboarding/presentation/location_onboarding_screen.dart';
import 'package:book_a_book/src/features/onboarding/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.showBack = true, this.header});

  final bool showBack;
  final Widget? header;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int firstStep = 1;

  final List<Widget> _pages = [
    const WelcomeScreen(),
    const HowItWorksScreen(), // Distinct Layout 1: e.g., Hero image + text
    const GenreSelectionScreen(), // DistinctGenreSelectionScreen Layout 2: e.g., Feature checklist + card
    const LocationOnboardingScreen(), // Distinct Layout 3: e.g., Interactive preview + button
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.md),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() {
                    firstStep = index;
                  }),
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
              if (widget.header != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Insets.md,
                    Insets.sm,
                    Insets.md,
                    0,
                  ),
                  child: widget.header,
                ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.md, 0),
              //   child: Row(
              //     children: [
              //       if (widget.showBack)
              //       //   IconButton(
              //       //     tooltip: 'Back',
              //       //     onPressed: () => _pages.length > 1
              //       //         ? _pageController.previousPage(
              //       //             duration: const Duration(milliseconds: 300),
              //       //             curve: Curves.easeInOut,
              //       //           )
              //       //         : null,
              //       //     icon: const Icon(Icons.arrow_back),
              //       //   )
              //       // else
              //       //   48.w.horizontalSpace,
              //       // const Spacer(),
              //       // Container(
              //       //   color: Colors.red,
              //       //   child: OnboardingProgressDots(step: widget.step),
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingProgressDots extends StatelessWidget {
  const OnboardingProgressDots({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Onboarding step $step of 5',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final active = index + 1 == step;
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : Insets.xs),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: active ? 22.w : 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              color: active ? AppColors.brandGreen : AppColors.cardBorder,
              borderRadius: AppRadius.pillAll,
            ),
          ),
        );
      }),
    ),
  );
}
