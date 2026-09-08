import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// "👤 Damilola S. ⋯ 4.9 ★" — on the card and again on the detail page.
class OwnerRatingRow extends StatelessWidget {
  const OwnerRatingRow({
    super.key,
    required this.name,
    this.avatarUrl,
    this.rating,
    this.avatarSize = 20,
  });

  final String name;
  final String? avatarUrl;

  /// **Nullable, and there is no rating column in the schema yet.** The mockup
  /// shows 4.9 / 4.5 / 4.9. Until ratings exist, pass `null` and the row renders
  /// without them — do not hardcode a number to match the mockup.
  final double? rating;

  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarSize.w / 2,
          backgroundColor: AppColors.cream,
          backgroundImage: avatarUrl == null || avatarUrl!.isEmpty
              ? null
              : CachedNetworkImageProvider(avatarUrl!),
          child: avatarUrl == null || avatarUrl!.isEmpty
              ? Text(
                  _initials(name),
                  style: AppTextStyle.ownerName.copyWith(
                    color: AppColors.inkMuted,
                  ),
                )
              : null,
        ),
        Insets.sm.horizontalSpace,
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.ownerName.copyWith(color: AppColors.ink),
          ),
        ),
        const Spacer(),
        if (rating != null) ...[
          Text(
            rating!.toStringAsFixed(1),
            style: AppTextStyle.ownerName.copyWith(color: AppColors.ink),
          ),
          Insets.xs.horizontalSpace,
          Icon(Icons.star_rounded, size: 14.w, color: AppColors.star),
        ],
      ],
    );
  }

  /// Duplicates `Profile.initials` on purpose: importing the profile domain
  /// here would weld this widget to a feature it does not otherwise need.
  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
