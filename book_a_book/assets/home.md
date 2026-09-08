# Home Screen — Specification

> **Source:** `assets/images/home.png`
> **Framework:** Flutter, Material 3, `flutter_screenutil`, `google_fonts` (Poppins)
> **Design system tokens:** `AppColors`, `AppTextStyle`, `AppRadius`, `Insets`

---

## 1. Page-Level Layout

```
Scaffold
├ backgroundColor: AppColors.cream
├ appBar: (see §2)
└ body: SafeArea
    └── SingleChildScrollView
        └── Column (crossAxisAlignment: stretch)
            ├── Hero Section (§3)
            ├── Genres Section (§4)
            ├── Books Section (§5)
            ├── How It Works Section (§6)
            ├── List a Book Banner (§7)
            └── Footer (§8)
```

Padding: `EdgeInsets.all(Insets.md)` on the `SingleChildScrollView`.

---

## 2. Top Bar

**Reuse `AppTopBar`** (from `core/widgets/app_top_bar.dart`).

| Prop | Value |
|---|---|
| `isSignedIn` | `false` |
| `onLogin` | `() => context.go(AppRoute.signIn.path)` |
| `onSignUp` | `() => context.go(AppRoute.signUp.path)` |
| `onMenu` | Open drawer |
| `backgroundColor` | `AppColors.cream` |

The bar renders: `AppLogo` (left) → spacer → `TextLinkButton('Login')` + `PrimaryButton('Sign Up')` + `IconButton(menu)` (right).

---

## 3. Hero Section

A full-width hero with a decorative image, tagline pill, and central text.

```
Container (the hero)
├ width: double.infinity
├ constraints: BoxConstraints(minHeight: 420.h)
├ color: AppColors.cream
└ child: Stack
    ├── Positioned (right: 0, bottom: 0)
    │   child: Image.asset('assets/images/image1 1.png',
    │       width: 0.58.sw, fit: BoxFit.contain)
    └── Padding (EdgeInsets.all(Insets.md))
        └── ConstrainedBox (maxWidth: 0.62.sw)
            └── Column (crossAxisAlignment: start, mainAxisSize: min)
                ├── TaglinePill (label: 'BORROW. READ. RETURN. REPEAT.', icon: Icons.menu_book_outlined)
                ├── Insets.lg.verticalSpace
                ├── Text.rich (heroTitle + brandGreen highlight)
                ├── Insets.md.verticalSpace
                ├── heroBody subtitle
                └── Row (feature badges)
```

Token mapping:

| Token | Value |
|---|---|
| Hero title color | `AppColors.ink` / `AppColors.brandGreen` |
| Hero body color | `AppColors.inkMuted` |
| Hero min height | `420.h` |
| Pill background | `AppColors.white` |
| Pill border radius | `AppRadius.pillAll` (999.r) |
| Pill padding | `EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)` |
| Pill icon size | `16.w`, color `AppColors.brandGreen` |
| Pill label style | `AppTextStyle.pillLabel` |
| Feature badge background | `AppColors.white` |
| Feature badge border radius | `AppRadius.pillAll` |
| Feature badge padding | `EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)` |
| Feature badge icon size | `16.w`, color `AppColors.brandGreen` |
| Feature badge title style | `AppTextStyle.featureTitle` (14sp / w600) |
| Feature badge title color | `AppColors.ink` |
| Feature badge subtitle style | `AppTextStyle.featureSub` (12sp / w400) |
| Feature badge subtitle color | `AppColors.inkMuted` |

The PNG has a transparent background, so it composites straight onto the cream with no cutout work.

---

## 4. Genres Section

**Reuse `SectionHeader`** and **`CategoryTile`** (from `core/widgets/` and `features/home/widgets/`).

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: SectionHeader(
        title: 'Explore by genre',
        onViewAll: () => context.go(AppRoute.books.path),
      ),
    ),
    Insets.md.verticalSpace,
    SizedBox(
      height: 88.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Insets.md),
        separatorBuilder: (_, _) => Insets.sm.horizontalSpace,
        itemCount: genreCount,
        itemBuilder: (context, i) => CategoryTile(
          icon: _iconFor(genre),
          label: genre,
          onTap: () => onGenreTap(genre),
        ),
      ),
    ),
  ],
)
```

Token mapping:

| Token | Value |
|---|---|
| Section header title style | `AppTextStyle.sectionTitle.copyWith(color: AppColors.ink)` |
| Section header subtitle / viewAll style | `AppTextStyle.viewAll` |
| Category tile height | `88.h` |
| Category tile horizontal padding | `Insets.md` |
| Category tile separator | `Insets.sm.horizontalSpace` |

---

## 5. Books Section

**Reuse `BookCard`** (from `features/books/presentation/widgets/book_card.dart`).

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md),
      child: SectionHeader(
        title: 'Available books near you',
        onViewAll: () => context.go(AppRoute.books.path),
      ),
    ),
    Insets.md.verticalSpace,
    SizedBox(
      height: 360.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Insets.md),
        separatorBuilder: (_, _) => Insets.md.horizontalSpace,
        itemCount: bookCount,
        itemBuilder: (context, i) => BookCard(
          book: entry,
          onTap: () => onBookTap(entry.id),
        ),
      ),
    ),
  ],
)
```

Token mapping:

| Token | Value |
|---|---|
| Section header title | same as §4 |
| Book card height | `360.h` (accommodates cover + title + author + stats) |
| Book card horizontal padding | `Insets.md` |
| Book card separator | `Insets.md.horizontalSpace` |

---

## 6. How It Works Section

A rounded card with 4 step icons in a Wrap layout.

```dart
Padding(
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
        Insets.lg.verticalSpace,
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
)
```

Token mapping:

| Token | Value |
|---|---|
| Card background | `AppColors.cream` |
| Card border radius | `AppRadius.lgAll` (16.r) |
| Card padding | `EdgeInsets.all(Insets.lg)` |
| Section title style | `AppTextStyle.sectionTitle.copyWith(color: AppColors.ink)` |
| Step title style | `AppTextStyle.stepTitle` |
| Step body style | `AppTextStyle.stepBody` |
| Wrap horizontal spacing | `Insets.md` |
| Wrap vertical spacing (runSpacing) | `Insets.lg` |
| Item width | fluid: `(constraints.maxWidth - Insets.md) / 2` |

---

## 7. List a Book Banner

**Reuse existing banner widget** from `features/home/presentation/widgets/list_a_book_banner.dart`.

---

## 8. Footer

**Reuse `AppFooter`** (from `core/widgets/app_footer.dart`).

---

## 9. Full Assembly (pseudo-code)

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: AppTopBar(
        isSignedIn: false,
        onLogin: () => context.go(AppRoute.signIn.path),
        onSignUp: () => context.go(AppRoute.signUp.path),
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        backgroundColor: AppColors.cream,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // §3 Hero section
            _HeroSection(),

            Insets.xl.verticalSpace,

            // §4 Genres section
            _GenresSection(...),

            Insets.xl.verticalSpace,

            // §5 Books section
            _BooksSection(...),

            Insets.xl.verticalSpace,

            // §6 How it works section
            _HowItWorksSection(),

            Insets.xl.verticalSpace,

            // §7 List a book banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.md),
              child: ListABookBanner(onTap: () => ...),
            ),

            Insets.xl.verticalSpace,

            // §8 Footer
            AppFooter(onLinkTap: (link) => ...),
          ],
        ),
      ),
    );
  }
}
```

---

## 10. Design Decisions & Notes

| Decision | Rationale |
|---|---|
| `cream` background on hero | Consistent with auth screens (`AuthScaffold`); provides contrast for white card fields |
| Transparent PNG compositing | The mockup's home.png has a transparent background — composites straight onto cream |
| `420.h` min hero height | Minimum to fit tagline + title + subtitle at scaled text sizes; larger text grows within `constraints` |
| `0.58.sw` and `0.62.sw` image widths | These are fractional `sw` values to inset the photo from screen edges; they reflow proportionally |
| Wrap layout for steps | The mockup's 2×2 grid connector line is dropped — a single Wrap handles variable-length descriptions without clipping |
| `CategoryTile` and `BookCard` reused from features | Existing widgets, consistent token usage; building them inline risks drift |
| No connector lines between steps | The numbers already carry sequence; a bending line in a grid would add visual noise |
| Feature badges use `AppColors.white` background | The mockup shows white pills on cream; pure fill contrast, no stroke |
| `inkMuted` (60% alpha) for subtitles | The mockup renders captions in pure black at tiny sizes; at real sizes, muted gives hierarchy without adding a new token |
| Genres and books use horizontal `ListView.separated` | The mockup shows pill-row and grid layout; horizontal `ListView` reflows at different widths |
| Footer reused from `core/widgets` | Auth and footer patterns are shared across features |
| Tile icons from Material | The mockup uses outlined icons; Material icons are the specified replacement (see `01-design-system.md` re: SVGs) |