import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_logo.dart';

/// The shell both auth screens share.
///
/// Cream rather than white *(chosen)* — it matches the hero the user just came
/// from, and keeps the white form fields distinct from the page.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.w, color: AppColors.ink),
          tooltip: 'Back',
          // `context.go` from the header replaces rather than pushes, so there
          // is often nothing to pop back to.
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: Center(
          // Not optional: the keyboard takes roughly half the viewport, and
          // without this a form of this height overflows the moment a field is
          // focused.
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Insets.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 32)),
                  SizedBox(height: Insets.lg),
                  Text(
                    title,
                    style: AppTextStyle.heroTitle.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: Insets.xs),
                  Text(
                    subtitle,
                    style: AppTextStyle.heroBody.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  SizedBox(height: Insets.xl),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "New here? **Sign up**" — the row that replaces the old `_isRegistering`
/// toggle.
class AuthSwitchRow extends StatelessWidget {
  const AuthSwitchRow({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
        ),
        SizedBox(width: Insets.xs),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: AppTextStyle.viewAll.copyWith(
              color: AppColors.brandGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
