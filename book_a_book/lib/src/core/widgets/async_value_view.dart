import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../errors/failure.dart';
import '../theme/app_theme.dart';

/// Renders the three states of an [AsyncValue] in one place.
///
/// Without this you re-type `loading: ... error: ...` on every screen, and the
/// loading spinner drifts out of sync across the app. This is the single
/// highest-leverage reusable widget in a Riverpod codebase.
///
/// Note it takes its data through the constructor and never reads a provider —
/// that is what keeps it reusable and trivially testable.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.builder,
    this.onRetry,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      // `skipLoadingOnRefresh: false` would flash a spinner on every pull to
      // refresh; keeping the stale data on screen feels much better.
      skipLoadingOnRefresh: true,
      data: builder,
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorView(error: error, onRetry: onRetry),
    );
  }
}

/// Turns a thrown object into something a person can read.
///
/// Because the adapter normalises everything to [Failure], this only has to
/// understand one type — that is the payoff of translating errors at the
/// boundary.
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error is Failure
        ? (error as Failure).message
        : 'Something went wrong.';

    return Center(
      child: Padding(
        // `Insets` values are ScreenUtil getters now, so these can no longer be
        // `const`. An unscaled layout is a real bug; a missing `const` is not.
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              error is NetworkFailure ? Icons.wifi_off : Icons.error_outline,
              size: 48.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: Insets.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              SizedBox(height: Insets.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when a query succeeds but returns nothing.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48.w, color: theme.colorScheme.outline),
            SizedBox(height: Insets.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[SizedBox(height: Insets.lg), action!],
          ],
        ),
      ),
    );
  }
}
