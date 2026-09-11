import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/buttons.dart';
import '../widgets/auth_scaffold.dart';

class CheckYourInbox extends StatelessWidget {
  const CheckYourInbox({
    required this.email,
    required this.onBackToSignIn,
    required this.onEditEmail,
  });

  final String email;
  final VoidCallback onBackToSignIn;
  final VoidCallback onEditEmail;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Check your inbox',
      subtitle: 'Confirm your address to finish setting up your account.',
      children: [
        Container(
          padding: EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.mdAll,
          ),
          child: Row(
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                size: 24.w,
                color: AppColors.brandGreen,
              ),
              Insets.md.horizontalSpace,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'We sent a confirmation link to ',
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                      TextSpan(
                        text: email,
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: 'Back to sign in',
          expand: true,
          onPressed: onBackToSignIn,
        ),
        Insets.sm.verticalSpace,
        Center(
          child: TextLinkButton(
            label: 'Use a different email',
            onPressed: onEditEmail,
          ),
        ),
      ],
    );
  }
}
