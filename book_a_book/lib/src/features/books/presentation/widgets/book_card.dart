import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../domain/book.dart';
import 'book_cover.dart';
import 'escrow_stat.dart';
import 'location_badge.dart';
import 'owner_rating_row.dart';

/// A vertical book card, sized for a horizontal carousel.
///
/// Note what this widget does *not* do: it does not extend `ConsumerWidget`, it
/// does not read a provider, and it does not know a repository exists. It takes
/// data in and sends events out. That is the rule that makes a widget genuinely
/// reusable — the moment it reaches for a provider it is welded to one screen's
/// state and can only be reused where that state exists.
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.ownerLocation,
    this.ownerRating,
    this.width = 150,
  });

  final Book book;
  final VoidCallback onTap;

  /// The owner's `Profile.locationText`. `Book` has no location field, and
  /// `BooksRepository._withOwner` does not select one today — pass `null` and
  /// the badge simply does not render. Do not invent a location.
  final String? ownerLocation;

  /// No rating column exists in the schema. Pass `null` until one does.
  final double? ownerRating;

  /// Design-pixel width for a carousel. Pass `null` to fill the available
  /// width instead — which is what a grid cell wants.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      child: Material(
        color: AppColors.white,
        clipBehavior: Clip.antiAlias,
        // No elevation: the mockup's cards are flat, separated from the white
        // page by a single warm hairline. `shape` carries the radius here —
        // Material asserts that `borderRadius` is null when `shape` is set.
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(Insets.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BookCover(
                  imageUrl: book.primaryCoverUrl,
                  width: double.infinity,
                  height: 190.h,
                  badge: ownerLocation == null
                      ? null
                      : LocationBadge(label: ownerLocation!),
                ),
                Insets.sm.verticalSpace,
                // Green, not black — the only text in the mockup that is
                // neither `ink` nor sitting on a green fill.
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardTitle.copyWith(
                    color: AppColors.brandGreen,
                  ),
                ),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardAuthor.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
                Insets.sm.verticalSpace,
                OwnerRatingRow(
                  name: book.owner?.name ?? 'Unknown',
                  avatarUrl: book.owner?.avatarUrl,
                  rating: ownerRating,
                ),
                Insets.sm.verticalSpace,
                // Both Flexible: "borrow period" is a long label in a narrow
                // card, and a fixed pair overflows the moment the text scale
                // goes up.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: EscrowStat(
                        value: EscrowStat.placeholder,
                        label: 'escrow',
                      ),
                    ),
                    Insets.xs.horizontalSpace,
                    const Flexible(
                      child: EscrowStat(
                        value: EscrowStat.placeholder,
                        label: 'borrow period',
                        accent: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
