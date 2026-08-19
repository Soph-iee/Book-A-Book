import 'package:flutter/material.dart';

import '../theme/app_text_style.dart';
import '../theme/color.dart';
import 'buttons.dart';

/// "Explore by category" + "View all".
///
/// The action is optional, which is what lets the same widget head a section
/// that has no overflow list.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
          ),
        ),
        if (onViewAll != null)
          TextLinkButton(label: 'View all', onPressed: onViewAll),
      ],
    );
  }
}
