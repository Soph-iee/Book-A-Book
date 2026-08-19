import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';

/// The five categories are **static presentation data**, not a database table.
///
/// `Book` carries a free-text `genre` and there is no `categories` table in
/// `core/supabase/tables.dart`, so there is nothing to fetch. Icons come from
/// the mapping in `01-design-system.md` — Material icons, not `assets/svg/`,
/// which are `<pattern>`-filled rasters that `flutter_svg` renders blank.
enum BookCategory {
  business('Business', Icons.business_center_outlined),
  selfHelp('Self Help', Icons.lightbulb_outline),
  education('Education', Icons.school_outlined),
  religious('Religious', Icons.church_outlined),
  fiction('Fiction', Icons.menu_book_outlined);

  const BookCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
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
    return SizedBox(
      // `.w` on both axes so the tile stays square. On a tall narrow phone `.w`
      // and `.h` diverge, and a `.w × .h` "square" comes out a rectangle.
      width: 88.w,
      height: 88.w,
      child: Material(
        color: AppColors.brandGreen,
        borderRadius: AppRadius.mdAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28.w, color: AppColors.white),
              SizedBox(height: Insets.sm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.xs),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.tileLabel.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
