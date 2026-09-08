import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color.dart';

/// Bottom shell for the signed-in app.
///
/// The bar is stateless: it is told which index is active and fires a callback
/// on tap, so the screen owns the selection and the route. The middle slot is
/// reserved for the floating "List +" action; pass [onListTap] to wire it.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onListTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onListTap;

  static const int listIndex = 2;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: AppColors.white,
      notchMargin: 6,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          _Item(
            index: 0,
            current: currentIndex,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            onTap: onTap,
          ),
          _Item(
            index: 1,
            current: currentIndex,
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore,
            label: 'Explore',
            onTap: onTap,
          ),
          const Spacer(),
          _Item(
            index: 3,
            current: currentIndex,
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: 'Activity',
            onTap: onTap,
          ),
          _Item(
            index: 4,
            current: currentIndex,
            icon: Icons.person_outlined,
            activeIcon: Icons.person,
            label: 'Profile',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.index,
    required this.current,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int current;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return IconButton(
      onPressed: () => onTap(index),
      icon: Icon(isActive ? activeIcon : icon, size: 24.w),
      color: isActive ? AppColors.brandGreen : AppColors.inkFaint,
      tooltip: label,
    );
  }
}
