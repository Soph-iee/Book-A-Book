import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color.dart';

class ScrimmedIcon extends StatelessWidget {
  const ScrimmedIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scrim,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, size: 20.w, color: AppColors.white),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
