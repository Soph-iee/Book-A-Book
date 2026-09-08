import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../books/presentation/view_models/books_view_model.dart';
import '../../../books/presentation/widgets/book_card.dart';
import '../widgets/genres_grid.dart';
import '../widgets/greeting_section.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_search_bar.dart';

/// Signed-in home at `/`: greeting, search, genres, available books, and a
/// bottom nav shell.
///
/// Stays a `ConsumerStatefulWidget` because the bottom-nav selection is local
/// UI state — it does not belong in a provider, and it does not survive
/// navigation. Session-driven state (signed-in flag, avatar initials) is read
/// from [currentSessionProvider] on every rebuild.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;

  String _initialsFromName(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _displayNameFromSession() {
    final session = ref.watch(currentSessionProvider);
    final meta = session?.user.userMetadata;
    final name = (meta?['full_name'] as String?) ??
        (meta?['name'] as String?) ??
        session?.user.email?.split('@').first;
    return name?.trim().isNotEmpty == true ? name! : 'there';
  }

  void _onNavTap(int i) {
    setState(() => _navIndex = i);
    switch (i) {
      case HomeBottomNav.listIndex:
        // TODO(backend): gate on `currentSessionProvider != null` and route to
        // the list-a-book form; signed out → `/sign-in`.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('List a Book is not wired up yet.')),
        );
      case 0:
        break;
      case 1:
        context.go(AppRoute.books.path);
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity is not wired up yet.')),
        );
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile is not wired up yet.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final isSignedIn = session != null;
    final displayName = _displayNameFromSession();
    final initials = _initialsFromName(
      (session?.user.userMetadata?['full_name'] as String?) ??
          (session?.user.userMetadata?['name'] as String?),
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppTopBar(
        isSignedIn: isSignedIn,
        avatarInitials: initials,
        onLogin: () => context.go(AppRoute.signIn.path),
        onSignUp: () => context.go(AppRoute.signUp.path),
        onMenu: () => Scaffold.of(context).openDrawer(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: Insets.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingSection(
                      name: displayName,
                      location: 'Yaba, Lagos',
                      onLocationTap: () {
                        // TODO(backend): open a location picker. The
                        // `LocationService` in core/services already provides
                        // a GPS + manual entry flow that can be reused.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location picker is not wired up yet.'),
                          ),
                        );
                      },
                    ),
                    Insets.md.verticalSpace,
                    HomeSearchBar(
                      onTap: () => context.go(AppRoute.books.path),
                      onFilterTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filters are not wired up yet.'),
                          ),
                        );
                      },
                    ),
                    Insets.lg.verticalSpace,
                    GenresGrid(
                      onGenreTap: (genre) => context.go(
                        AppRoute.books.path,
                        extra: genre,
                      ),
                    ),
                    Insets.lg.verticalSpace,
                    _AvailableSection(
                      onViewAll: () => context.go(AppRoute.books.path),
                    ),
                    Insets.md.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.md),
                      child: SecondaryButton(
                        label: 'Explore all books',
                        icon: Icons.arrow_forward,
                        expand: true,
                        onPressed: () => context.go(AppRoute.books.path),
                      ),
                    ),
                    Insets.lg.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// -------------------------------------------------- Available near you

class _AvailableSection extends ConsumerWidget {
  const _AvailableSection({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooks = ref.watch(booksViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Available near you',
                  style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
                ),
              ),
              TextLinkButton(label: 'See all', onPressed: onViewAll),
            ],
          ),
        ),
        Insets.sm.verticalSpace,
        SizedBox(
          height: 260.h,
          child: AsyncValueView<List<Book>>(
            value: asyncBooks,
            onRetry: () => ref.invalidate(booksViewModelProvider),
            builder: (books) {
              if (books.isEmpty) {
                return const EmptyStateView(
                  message: 'No books available right now.',
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Insets.md),
                itemCount: books.length,
                separatorBuilder: (_, _) => Insets.md.horizontalSpace,
                itemBuilder: (context, i) {
                  final entry = books[i];
                  return BookCard(
                    book: entry,
                    ownerLocation: entry.owner?.locationText,
                    ownerRating: null,
                    onTap: () => context.go(AppRoute.bookDetailPath(entry.id)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}