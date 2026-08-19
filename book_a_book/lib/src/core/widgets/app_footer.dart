import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';
import 'app_logo.dart';

enum FooterLink {
  about('About us'),
  terms('Terms'),
  refundPolicy('Refund policy');

  const FooterLink(this.label);

  final String label;
}

/// Full-bleed green footer.
///
/// **Reflow note:** the mockup puts logo, links and copyright on one 786px row.
/// At 393pt that row cannot hold them, so it stacks — logo, then a [Wrap] of
/// links, then the copyright.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key, required this.onLinkTap});

  final void Function(FooterLink link) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.brandGreen,
      padding: EdgeInsets.symmetric(vertical: Insets.lg, horizontal: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogo(variant: AppLogoVariant.light, size: 22),
          SizedBox(height: Insets.md),
          Wrap(
            spacing: 16.w,
            runSpacing: Insets.sm,
            children: [
              for (final link in FooterLink.values)
                GestureDetector(
                  onTap: () => onLinkTap(link),
                  child: Text(
                    link.label,
                    style: AppTextStyle.footerLink.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: Insets.md),
          Text(
            '©2026 Book-A-Book',
            style: AppTextStyle.footerLink.copyWith(
              color: AppColors.whiteMuted,
            ),
          ),
        ],
      ),
    );
  }
}
