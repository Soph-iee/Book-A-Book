import 'package:book_a_book/src/core/router/router_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/buttons.dart';
import '../widgets/available_section.dart';
import '../widgets/genres_grid.dart';
import '../widgets/greeting_section.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_search_bar.dart';


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
                    AvailableSection(
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