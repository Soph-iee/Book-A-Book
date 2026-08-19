import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// A book cover with an optional badge over it.
///
/// Pulled out of the private `_Cover` that used to live in `book_card.dart`, so
/// the detail screen can reuse it at a larger size.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.badge,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? imageUrl;
  final double width;
  final double height;

  /// A [LocationBadge], positioned bottom-left.
  final Widget? badge;

  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.smAll;

    // A book with a broken cover URL must not render as a grey void.
    final fallback = Container(
      width: width,
      height: height,
      color: AppColors.cream,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_outlined,
        size: 32.w,
        color: AppColors.inkFaint,
      ),
    );

    final image = imageUrl == null || imageUrl!.isEmpty
        ? fallback
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, _) =>
                Container(width: width, height: height, color: AppColors.cream),
            errorWidget: (_, _, _) => fallback,
          );

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            if (badge != null)
              Positioned(bottom: 8.w, left: 8.w, child: badge!),
          ],
        ),
      ),
    );
  }
}
