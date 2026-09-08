import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_style.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';

/// Three buttons in one file because they are variants of one idea, and
/// splitting them would mean three imports at every use site.

/// Filled green. "Sign Up" and "List a Book" in the mockup.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.isLoading = false,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;

  /// Trailing, e.g. the arrow on "List a Book".
  final IconData? icon;

  /// Full-width (auth screens) vs hug (header).
  final bool expand;

  /// Swaps the label for a spinner *inside* the button, so the button keeps its
  /// size and the surrounding form does not jump — which an external spinner
  /// cannot do.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brandGreen,
        foregroundColor: AppColors.onGreen,
        // Stay fully coloured while loading; only a genuinely disabled button
        // should look faded.
        disabledBackgroundColor: isLoading
            ? AppColors.brandGreen
            : AppColors.greenDisabled,
        disabledForegroundColor: AppColors.onGreen,
        minimumSize: Size(0, 44.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        textStyle: AppTextStyle.buttonLabel,
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.onGreen,
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Outlined green on white.
///
/// Not in the mockup as drawn; it exists because the book detail screen needs a
/// low-emphasis action next to the borrow CTA. Noted so it does not look
/// invented.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.brandGreen,
        disabledForegroundColor: AppColors.greenDisabled,
        side: BorderSide(color: AppColors.brandGreen, width: 1.w),
        minimumSize: Size(0, 44.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        textStyle: AppTextStyle.buttonLabel,
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.brandGreen,
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Unfilled, borderless. "Login" and "View all" in the mockup.
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandGreen,
        disabledForegroundColor: AppColors.greenDisabled,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        minimumSize: Size(0, 36.h),
        textStyle: AppTextStyle.viewAll,
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: false,
        color: AppColors.brandGreen,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.color,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 18.w,
        height: 18.w,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    if (icon == null) return Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        Insets.sm.horizontalSpace,
        Icon(icon, size: 18.w, color: color),
      ],
    );
  }
}
