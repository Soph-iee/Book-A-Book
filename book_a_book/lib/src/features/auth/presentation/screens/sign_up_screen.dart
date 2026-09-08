import 'package:book_a_book/src/features/auth/presentation/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../presentation/view_models/auth_view_model.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../widgets/auth_scaffold.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _submitted = false;
  bool _signUpSucceeded = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(authViewModelProvider.notifier)
        .signUp(email: _email.text, password: _password.text, name: _name.text);
    final callSucceeded = !ref.read(authViewModelProvider).hasError;
    if (mounted && callSucceeded) {
      setState(() {
        _submitted = true;
        _signUpSucceeded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_messageFor(error)))),
      );
    });

    final hasSession = ref.watch(currentSessionProvider) != null;
    if (_signUpSucceeded && !hasSession) {
      return _CheckYourInbox(
        email: _email.text.trim(),
        onBackToSignIn: () => context.go(AppRoute.signIn.path),
        onEditEmail: () => setState(() => _submitted = false),
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
              Insets.md.verticalSpace,
              AppTextField(
                controller: _email,
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: AuthValidators.email,
              ),
              Insets.md.verticalSpace,
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
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: 'Create account',
          expand: true,
          isLoading: authState.isLoading,
          onPressed: _submit,
        ),
        Insets.md.verticalSpace,
        AuthSwitchRow(
          prompt: 'Already have an account?',
          action: 'Sign in',
          onTap: () => context.go(AppRoute.signIn.path),
        ),
      ],
    );
  }

  String _messageFor(Object error) {
    if (error is Failure) {
      return authFriendlyMessage(error);
    }
    return 'Something went wrong. Please try again.';
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
