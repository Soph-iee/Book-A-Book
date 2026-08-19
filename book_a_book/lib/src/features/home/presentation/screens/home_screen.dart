import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_footer.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/tagline_pill.dart';
import '../../../books/data/sample_books.dart';
import '../../../books/presentation/widgets/book_card.dart';
import '../widgets/category_tile.dart';
import '../widgets/feature_badge.dart';
import '../widgets/how_it_works_step.dart';
import '../widgets/list_a_book_banner.dart';

/// The app's **public** landing page at `/`: signed-out visitors browse freely
/// and only hit the auth wall when they act.
///
/// A `CustomScrollView` would be the wrong instinct here — there is no sliver
/// behaviour, no pinned header and no lazy section. The two carousels are the
/// only lazy lists.
///
/// TODO(backend): this becomes a `ConsumerStatefulWidget` watching
/// `booksControllerProvider` for the carousel and `currentSessionProvider` for
/// the top bar. Everything below this screen stays provider-free.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // The top bar's menu callback fires from a context above the Scaffold, so
  // `Scaffold.of` cannot find it. A key can.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _notWired(String what) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$what is not wired up yet.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: AppTopBar(
        // TODO(backend): ref.watch(currentSessionProvider) != null
        isSignedIn: false,
        onLogin: () => context.go(AppRoute.signIn.path),
        onSignUp: () => context.go(AppRoute.signUp.path),
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const _HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeroSection(),
            SizedBox(height: Insets.xl),
            _CategoriesSection(
              onViewAll: () => context.go(AppRoute.books.path),
              // TODO(backend): route to a genre-filtered list. BooksRepository
              // has `search()` but no genre filter, so this either needs one
              // added or should pass the category name as the search query.
              onCategoryTap: (category) => context.go(AppRoute.books.path),
            ),
            SizedBox(height: Insets.xl),
            _BooksSection(
              onViewAll: () => context.go(AppRoute.books.path),
              onBookTap: (id) => context.go(AppRoute.bookDetailPath(id)),
            ),
            SizedBox(height: Insets.xl),
            const _HowItWorksSection(),
            SizedBox(height: Insets.xl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.md),
              // TODO(backend): signed in → the list-a-book form; signed out →
              // /sign-up. That decision belongs here, not in the widget.
              child: ListABookBanner(onTap: () => _notWired('Listing a book')),
            ),
            SizedBox(height: Insets.xl),
            AppFooter(onLinkTap: (link) => _notWired(link.label)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- 1 · Hero

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      // A minimum, not a fixed height: at large text scales the copy grows and
      // a fixed hero clips it.
      constraints: BoxConstraints(minHeight: 420.h),
      child: Stack(
        children: [
          // The PNG has a transparent background, so it composites straight
          // onto the cream with no cutout work.
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/image1 1.png',
              width: 0.58.sw,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Insets.md),
            child: ConstrainedBox(
              // Never runs under the photo.
              constraints: BoxConstraints(maxWidth: 0.62.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TaglinePill(
                    label: 'BORROW. READ. RETURN. REPEAT.',
                    icon: Icons.menu_book_outlined,
                  ),
                  SizedBox(height: Insets.lg),
                  // One RichText rather than two Texts in a Column: the
                  // mockup's two lines are one paragraph with a colour change,
                  // and stacking them separately makes the line spacing drift
                  // from the scale's height: 1.2.
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Your Next Read\n',
                          style: AppTextStyle.heroTitle.copyWith(
                            color: AppColors.ink,
                          ),
                        ),
                        TextSpan(
                          text: "Is on Someone's Shelf.",
                          style: AppTextStyle.heroTitle.copyWith(
                            color: AppColors.brandGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.md),
                  Text(
                    'Connect with readers around you and borrow books safely.',
                    style: AppTextStyle.heroBody.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  SizedBox(height: Insets.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(
                        child: FeatureBadge(
                          icon: Icons.verified_user_outlined,
                          title: 'Safe & Secure',
                          subtitle: 'Escrow protection',
                        ),
                      ),
                      SizedBox(width: Insets.md),
                      const Flexible(
                        child: FeatureBadge(
                          icon: Icons.menu_book_outlined,
                          title: 'Free to Borrow',
                          subtitle: 'Pay escrow only',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------- 2 · Explore by category

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({
    required this.onViewAll,
    required this.onCategoryTap,
  });

  final VoidCallback onViewAll;
  final void Function(BookCategory category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.md),
          child: SectionHeader(
            title: 'Explore by category',
            onViewAll: onViewAll,
          ),
        ),
        SizedBox(height: Insets.md),
        SizedBox(
          // `.w` — the tiles are square.
          height: 88.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // The padding lives on the ListView, not on a wrapping Padding.
            // That keeps the first tile on the page margin while letting the
            // last one scroll to the screen edge, which is what makes a
            // carousel read as scrollable.
            padding: EdgeInsets.symmetric(horizontal: Insets.md),
            itemCount: BookCategory.values.length,
            separatorBuilder: (_, _) => SizedBox(width: Insets.sm),
            itemBuilder: (context, i) {
              final category = BookCategory.values[i];
              return CategoryTile(
                icon: category.icon,
                label: category.label,
                onTap: () => onCategoryTap(category),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------ 3 · Available books near you

class _BooksSection extends StatelessWidget {
  const _BooksSection({required this.onViewAll, required this.onBookTap});

  final VoidCallback onViewAll;
  final void Function(int bookId) onBookTap;

  @override
  Widget build(BuildContext context) {
    // TODO(backend): replace with
    //   AsyncValueView(value: ref.watch(booksControllerProvider), builder: ...)
    // which already renders the loading, error and empty branches.
    final books = sampleBooks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.md),
          // NOTE: "near you" is currently aspirational — `fetchAvailable()`
          // orders by recency, not proximity. `Rpcs.booksNearby` exists in
          // tables.dart as an unused constant. Either wire it or soften the
          // copy to "Available books".
          child: SectionHeader(
            title: 'Available books near you',
            onViewAll: onViewAll,
          ),
        ),
        SizedBox(height: Insets.md),
        SizedBox(
          // 360 rather than the spec's 320: a 190.h cover plus the title,
          // author, owner row and stat row does not fit in 320 at scale 1.
          height: 360.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Insets.md),
            itemCount: books.length,
            separatorBuilder: (_, _) => SizedBox(width: Insets.md),
            itemBuilder: (context, i) {
              final entry = books[i];
              return BookCard(
                book: entry.book,
                ownerLocation: entry.ownerLocation,
                // No rating column exists in the schema. Do not invent one.
                ownerRating: null,
                onTap: () => onBookTap(entry.book.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------- 4 · How it works

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  static const _steps = [
    (
      icon: Icons.search,
      title: '1. Find a book',
      body: 'Search and find books near you',
    ),
    (
      icon: Icons.account_balance_wallet_outlined,
      title: '2. Pay escrow',
      body: 'Pay a refundable escrow to the platform',
    ),
    (
      icon: Icons.menu_book_outlined,
      title: '3. Borrow & read',
      body: 'Meet up, borrow the book, and enjoy your read',
    ),
    (
      icon: Icons.shield_outlined,
      title: '4. Return & get refund',
      body: 'Return the book in good condition and get your escrow back',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: AppRadius.lgAll,
        ),
        child: Column(
          children: [
            Text(
              'How it works',
              style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: Insets.lg),
            // A Wrap rather than a GridView: it does not force a uniform tile
            // height, so the longer step-4 description will not clip at large
            // text scales.
            //
            // The mockup's connector line between steps is dropped — it
            // communicates sequence in a single row, in a 2×2 grid it would
            // have to bend, and the numbers already carry the ordering.
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - Insets.md) / 2;
                return Wrap(
                  spacing: Insets.md,
                  runSpacing: Insets.lg,
                  children: [
                    for (final step in _steps)
                      SizedBox(
                        width: itemWidth,
                        child: HowItWorksStep(
                          icon: step.icon,
                          title: step.title,
                          description: step.body,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Drawer

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Insets.md),
              child: const AppLogo(size: 24),
            ),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () => context.go(AppRoute.home.path),
            ),
            _DrawerItem(
              icon: Icons.menu_book_outlined,
              label: 'Browse books',
              onTap: () => context.go(AppRoute.books.path),
            ),
            _DrawerItem(
              icon: Icons.login,
              label: 'Login',
              onTap: () => context.go(AppRoute.signIn.path),
            ),
            _DrawerItem(
              icon: Icons.person_add_alt,
              label: 'Sign up',
              onTap: () => context.go(AppRoute.signUp.path),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22.w, color: AppColors.brandGreen),
      title: Text(
        label,
        style: AppTextStyle.body.copyWith(color: AppColors.ink),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
