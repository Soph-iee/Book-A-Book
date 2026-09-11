import 'package:book_a_book/src/core/errors/failure.dart';
import 'package:book_a_book/src/core/router/router_enum.dart';
import 'package:book_a_book/src/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../auth_validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/forgot_password_dialog.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final userEmail = _email.text.trim();
    final userPassword = _password.text.trim();
    await ref
        .read(authViewModelProvider.notifier)
        .signIn(email: userEmail, password: userPassword);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen(authViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_messageFor(error)))),
        data: (data) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signed in successfully'))),
        // Do NOT navigate here — see below.
      );
    });

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to borrow books near you.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                autofillHints: const [AutofillHints.password],
                validator: AuthValidators.password,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextLinkButton(
            label: 'Forgot password?',
            onPressed: () => _showForgotPassword(context),
          ),
        ),
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: 'Sign in',
          expand: true,
          onPressed: _submit,
          isLoading: authState.isLoading,
        ),
        Insets.md.verticalSpace,
        AuthSwitchRow(
          prompt: 'New here?',
          action: 'Sign up',
          onTap: () => context.go(AppRoute.signUp.path),
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

  void _showForgotPassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const ForgotPasswordDialog(),
    );
  }
}
