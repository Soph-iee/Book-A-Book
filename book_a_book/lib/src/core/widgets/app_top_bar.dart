import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';
import 'app_logo.dart';
import 'buttons.dart';

/// The header: logo left; Login, Sign Up and a hamburger right.
///
/// The hamburger opens a `Drawer` owned by the *screen*, not by this widget —
/// [onMenu] is a callback so the bar stays provider-free and layout-agnostic.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.isSignedIn,
    this.onLogin,
    this.onSignUp,
    this.onMenu,
    this.onLogoTap,
    this.avatarInitials,
    this.backgroundColor = AppColors.cream,
  });

  final bool isSignedIn;
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp;
  final VoidCallback? onMenu;
  final VoidCallback? onLogoTap;

  /// Shown in the avatar when [isSignedIn]. Passed in rather than derived, so
  /// this widget never imports the profile domain.
  final String? avatarInitials;

  /// A parameter because the header sits on cream at home and on white
  /// elsewhere.
  final Color backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.md),
            child: Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: onLogoTap,
                    child: const AppLogo(size: 22),
                  ),
                ),
                const Spacer(),
                if (isSignedIn)
                  _Avatar(initials: avatarInitials)
                else ...[
                  TextLinkButton(label: 'Login', onPressed: onLogin),
                  SizedBox(width: Insets.xs),
                  PrimaryButton(label: 'Sign Up', onPressed: onSignUp),
                ],
                SizedBox(width: Insets.xs),
                IconButton(
                  onPressed: onMenu,
                  icon: Icon(Icons.menu, size: 24.w, color: AppColors.ink),
                  tooltip: 'Menu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.initials});

  final String? initials;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16.w,
      backgroundColor: AppColors.brandGreen,
      child: Text(
        initials ?? '?',
        style: AppTextStyle.ownerName.copyWith(color: AppColors.white),
      ),
    );
  }
}
