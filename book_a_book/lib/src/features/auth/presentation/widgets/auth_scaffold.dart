import 'package:book_a_book/src/core/router/router_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_logo.dart';


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
    
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: Center(
   
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Insets.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 32)),
                  Insets.lg.verticalSpace,
                  Text(
                    title,
                    style: AppTextStyle.heroTitle.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  Insets.xs.verticalSpace,
                  Text(
                    subtitle,
                    style: AppTextStyle.heroBody.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  Insets.xl.verticalSpace,
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
        Insets.xs.horizontalSpace,
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
