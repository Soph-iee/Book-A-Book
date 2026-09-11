import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../widgets/title_block.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({required this.tags, super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
        ),
        Insets.sm.verticalSpace,
        Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            for (final tag in tags)
              DetailChip(
                label: tag,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tag search is not wired up yet.'),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
