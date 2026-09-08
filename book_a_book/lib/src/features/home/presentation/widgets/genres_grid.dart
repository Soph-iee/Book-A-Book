import 'package:book_a_book/src/features/books/presentation/view_models/books_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// A flat 2x2 genre tile, distinct from the existing green [CategoryTile] which
/// is meant for a horizontal pill-row carousel. The mockup shows the genres as
/// white cards on cream with a green icon and dark label, so this is its own
/// widget rather than a recoloured twin.
class GenreGridTile extends StatelessWidget {
  const GenreGridTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: AppRadius.mdAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Insets.sm),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: AppRadius.mdAll,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22.w, color: AppColors.brandGreen),
              ),
              Insets.sm.horizontalSpace,
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyle.tileLabel.copyWith(color: AppColors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2x2 grid of genres driven by the async [availableGenresProvider]. The grid
/// is fixed at four slots: it shows the first four available genres and renders
/// placeholders for any missing slots so the layout never collapses.
class GenresGrid extends ConsumerWidget {
  const GenresGrid({super.key, required this.onGenreTap});

  final ValueChanged<String> onGenreTap;

  static IconData _iconFor(String genre) => switch (genre.toLowerCase()) {
    'business' => Icons.business_center_outlined,
    'self help' => Icons.lightbulb_outline,
    'education' => Icons.school_outlined,
    'religious' => Icons.church_outlined,
    'fiction' => Icons.menu_book_outlined,
    'science fiction' => Icons.rocket_launch_outlined,
    'history' => Icons.history_edu_outlined,
    _ => Icons.menu_book_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGenres = ref.watch(availableGenresProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Genres',
            style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
          ),
          Insets.sm.verticalSpace,
          asyncGenres.when(
            loading: () => const _GridSkeleton(),
            error: (_, _) => const _GridError(),
            data: (genres) {
              final items = genres.take(4).toList();
              // Pad to four so the grid keeps its 2x2 shape.
              while (items.length < 4) {
                items.add('—');
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Insets.md,
                  mainAxisSpacing: Insets.md,
                  mainAxisExtent: 64.h,
                ),
                itemCount: 4,
                itemBuilder: (context, i) {
                  final label = items[i];
                  final enabled = label != '—';
                  return GenreGridTile(
                    icon: _iconFor(label),
                    label: label,
                    onTap: enabled ? () => onGenreTap(label) : () {},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Insets.md,
        mainAxisSpacing: Insets.md,
        mainAxisExtent: 64.h,
      ),
      itemCount: 4,
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.mdAll,
        ),
      ),
    );
  }
}

class _GridError extends StatelessWidget {
  const _GridError();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.md),
      child: Text(
        'Could not load genres.',
        style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
      ),
    );
  }
}