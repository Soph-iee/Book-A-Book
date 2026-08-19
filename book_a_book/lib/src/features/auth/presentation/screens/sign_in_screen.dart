import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../auth_validators.dart';
import '../widgets/auth_scaffold.dart';

/// Sign in.
///
/// This screen used to do both jobs, toggled by a private `_isRegistering`
/// bool. It is split from sign-up because the header puts *Login* and *Sign Up*
/// side by side as separate destinations, and a shared screen would mean the
/// header's two buttons lead to the same route in different internal states —
/// which cannot be linked, cannot be deep-linked, and reads wrong in the back
/// stack.
///
/// TODO(backend): becomes a `ConsumerStatefulWidget`.
///   - `final state = ref.watch(authControllerProvider)` feeds
///     `isLoading: state.isLoading` on the button.
///   - `ref.listen(authControllerProvider, ...)` shows the error SnackBar —
///     `ref.watch` would re-show it on every unrelated rebuild.
///   - `_submit` calls
///     `ref.read(authControllerProvider.notifier).signIn(email:, password:)`.
///   - **Do not navigate on success.** `app_router.dart` already listens to the
///     auth stream through `_AuthRefreshNotifier`, so a successful sign-in
///     re-runs `redirect` on its own; a `context.go()` here would race it.
///   - Map errors with a switch over the sealed `Failure` hierarchy, never the
///     raw Supabase message — it leaks whether an email is registered.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    // Controllers hold native resources; leaking them is the most common
    // memory bug in Flutter forms.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Placeholder for the controller call. The delay exists only so the
    // button's loading state is visible during a design review.
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in is not wired up yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: Insets.md),
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
        SizedBox(height: Insets.lg),
        PrimaryButton(
          label: 'Sign in',
          expand: true,
          isLoading: _isSubmitting,
          onPressed: _submit,
        ),
        SizedBox(height: Insets.md),
        AuthSwitchRow(
          prompt: 'New here?',
          action: 'Sign up',
          onTap: () => context.go(AppRoute.signUp.path),
        ),
      ],
    );
  }

  void _showForgotPassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _ForgotPasswordDialog(),
    );
  }
}

/// `AuthRepository.sendPasswordReset(email)` exists but **`AuthController` does
/// not expose it**, so this collects the address and stops there for now.
///
/// TODO(backend): add a `sendPasswordReset` command to `AuthController`
/// mirroring the others (`state = loading; state = await AsyncValue.guard(...)`)
/// and call it from here.
class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _send() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset is not wired up yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      title: Text(
        'Reset your password',
        style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'We will email you a link to choose a new one.',
              style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
            ),
            SizedBox(height: Insets.md),
            AppTextField(
              controller: _email,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: AuthValidators.email,
              onSubmitted: (_) => _send(),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(Insets.md, 0, Insets.md, Insets.md),
      actions: [
        TextLinkButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        PrimaryButton(label: 'Send link', onPressed: _send),
      ],
    );
  }
}
