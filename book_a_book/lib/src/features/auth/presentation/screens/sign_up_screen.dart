import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../auth_validators.dart';
import '../widgets/auth_scaffold.dart';

/// Sign up.
///
/// TODO(backend): becomes a `ConsumerStatefulWidget` calling
/// `ref.read(authControllerProvider.notifier).signUp(email:, password:, name:)`,
/// with `isLoading` and the error SnackBar wired exactly as described in
/// `sign_in_screen.dart`.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isSubmitting = false;

  /// Non-null once the form has been submitted, which swaps the form for the
  /// confirmation state.
  ///
  /// TODO(backend): the real condition is "signUp succeeded but
  /// `currentSessionProvider` is still null". If the Supabase project has email
  /// confirmation enabled, `signUp` returns a `User` with **no `Session`** — the
  /// user is not signed in and the router will not move, so a screen that
  /// assumes success means signed-in appears to hang.
  String? _pendingConfirmationFor;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _pendingConfirmationFor = _email.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingConfirmationFor != null) {
      return _CheckYourInbox(
        email: _pendingConfirmationFor!,
        onBackToSignIn: () => context.go(AppRoute.signIn.path),
        onEditEmail: () => setState(() => _pendingConfirmationFor = null),
      );
    }

    return AuthScaffold(
      title: 'Create your account',
      subtitle: 'Join readers sharing books near you.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _name,
                label: 'Name',
                hint: 'Damilola Soyinka',
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: AuthValidators.name,
              ),
              SizedBox(height: Insets.md),
              AppTextField(
                controller: _email,
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: AuthValidators.email,
              ),
              SizedBox(height: Insets.md),
              AppTextField(
                controller: _password,
                label: 'Password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: AuthValidators.password,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        SizedBox(height: Insets.lg),
        PrimaryButton(
          label: 'Create account',
          expand: true,
          isLoading: _isSubmitting,
          onPressed: _submit,
        ),
        SizedBox(height: Insets.md),
        AuthSwitchRow(
          prompt: 'Already have an account?',
          action: 'Sign in',
          onTap: () => context.go(AppRoute.signIn.path),
        ),
      ],
    );
  }
}

class _CheckYourInbox extends StatelessWidget {
  const _CheckYourInbox({
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
              SizedBox(width: Insets.md),
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
        SizedBox(height: Insets.lg),
        PrimaryButton(
          label: 'Back to sign in',
          expand: true,
          onPressed: onBackToSignIn,
        ),
        SizedBox(height: Insets.sm),
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
