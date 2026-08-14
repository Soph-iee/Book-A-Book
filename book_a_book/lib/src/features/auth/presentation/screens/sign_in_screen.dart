import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  bool _isRegistering = false;

  @override
  void dispose() {
    // Controllers hold native resources; leaking them is the most common
    // memory bug in Flutter forms.
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(authControllerProvider.notifier);

    if (_isRegistering) {
      await controller.signUp(
        email: _email.text,
        password: _password.text,
        name: _name.text,
      );
    } else {
      await controller.signIn(email: _email.text, password: _password.text);
    }
    // No navigation here on purpose — the router's redirect reacts to the auth
    // stream, so a successful sign-in moves the user automatically. One source
    // of truth for "am I signed in".
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    ref.listen(authControllerProvider, (previous, next) {
      final error = next.error;
      if (error == null || next.isLoading) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is Failure ? error.message : 'Could not sign you in.',
          ),
        ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: Insets.md),
                    Text(
                      'Book-A-Book',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: Insets.xs),
                    Text(
                      _isRegistering
                          ? 'Create an account to start lending.'
                          : 'Welcome back.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Insets.xl),
                    if (_isRegistering) ...[
                      TextFormField(
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Please enter your name'
                                : null,
                      ),
                      const SizedBox(height: Insets.md),
                    ],
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Please enter your email';
                        if (!text.contains('@')) return 'That does not look right';
                        return null;
                      },
                    ),
                    const SizedBox(height: Insets.md),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => (value?.length ?? 0) < 6
                          ? 'At least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: Insets.lg),
                    FilledButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isRegistering ? 'Create account' : 'Sign in'),
                    ),
                    const SizedBox(height: Insets.sm),
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () => setState(
                                () => _isRegistering = !_isRegistering,
                              ),
                      child: Text(
                        _isRegistering
                            ? 'I already have an account'
                            : 'Create an account',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
