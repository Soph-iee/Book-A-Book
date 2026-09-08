import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/buttons.dart';

/// The green "Have books on your shelf?" call to action.
///
/// **Reflow note:** the mockup lays this out image | text | button on one 786px
/// row. At 393pt the image and text share a row and the button drops to a
/// full-width line beneath.
class ListABookBanner extends StatelessWidget {
  const ListABookBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  /// Registered by the `assets/images/` entry in `pubspec.yaml`. The name has
  /// spaces and is unwieldy; renaming it to `book_stack.png` and updating this
  /// one reference is a reasonable first act.
  static const String _bookStackAsset =
      'assets/images/pngtree-5-hardbooks-sitting-on-each-other-with-quotes-png-image_18725745-removebg-preview 1.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.brandGreen,
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                _bookStackAsset,
                width: 72.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => SizedBox(width: 72.w),
              ),
              Insets.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Have books on your shelf?',
                      style: AppTextStyle.bannerTitle.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Insets.xs.verticalSpace,
                    Text(
                      'List them and help others read.',
                      style: AppTextStyle.bannerBody.copyWith(
                        color: AppColors.whiteMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Insets.md.verticalSpace,
          // White fill, green label. The SecondaryButton's green border sits
          // against the green banner, so it reads as a plain white pill here.
          SecondaryButton(
            label: 'List a Book',
            icon: Icons.arrow_forward,
            expand: true,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
