# Home Screen Spec

Source: `assets/images/home.png`
Framework: Flutter, Material 3, flutter_screenutil, Poppins

## 1. Page-Level Layout

```
Scaffold
├ backgroundColor: AppColors.cream
├ appBar: AppTopBar(isSignedIn: true, avatarInitials: ...)
└ body: SafeArea
    └── Column (cross-axis: stretch)
        ├── Greeting row
        ├── Search bar
        ├── Genres 2x2 grid
        ├── Available near you
        ├── Explore all books
        └── BottomNav
```

Padding: ` EdgeInsets.all(Insets.md)` on the body Column.

## 2. Top Bar

Reuse `AppTopBar` with `isSignedIn: true`, `avatarInitials: 'AM'`.
Default `backgroundColor: AppColors.cream`.

## 3. Greeting

```
Padding(Insets.md) → Column(crossAxis: start) → [
  Text('Good afternoon,', AppTextStyle.sectionTitle × ink),
  Row → Text('Amara', sectionTitle × brandGreen) + Dropdown(location),
]
```

## 4. Search

```
Padding(Insets.md) → Container(
  color: white, borderRadius: AppRadius.mdAll,
  child: TextField(decoration: EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
    hint: 'Search by title, author or genre',
    prefixIcon: Icons.search, suffixIcon: Icons.filter_list),
)
```

## 5. Genres (2x2 grid)

```
Padding(Insets.md) → Column(crossAxis: start) → [
  Text('Genres', sectionTitle × ink),
  Insets.sm.verticalSpace,
  GridView.builder(
    shrinkWrap: true, physics: NeverScrollableScrollPhysics,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, crossAxisSpacing: Insets.md, mainAxisSpacing: Insets.md,
      mainAxisExtent: 100.h),
    itemCount: 4,
    itemBuilder: (_, i) => CategoryTile2x2(genre: g),
  ),
]
```

Genre tiles: cream background, rounded `AppRadius.mdAll`, icon (28.w, brandGreen) + label (13sp w600, ink).

## 6. Available near you

```
Padding(Insets.md) → Column(crossAxis: start) → [
  Row(mainAxis: spaceBetween) → [
    Text('Available near you', sectionTitle × ink),
    TextLinkButton('See all', → /books),
  ],
  Insets.sm.verticalSpace,
  SizedBox(height: 260.h) → ListView.separated(
    scrollDirection: horizontal, padding: EdgeInsets.symmetric(horizontal: Insets.md),
    separatorBuilder: (_, _) => Insets.md.horizontalSpace,
    itemBuilder: (_, i) => BookCard(book: b, onTap: → /books/:id),
  ],
]
```

Book card fields: cover (190.h), title (brandGreen), author (inkMuted), owner row (name + avatar + rating star), distance badge (1.2km), escrow (₦5,000), borrow period (14 Days).

## 7. Explore all books

```
Padding(Insets.md) → SecondaryButton('Explore all books', icon: arrow_forward, expand: true, → /books)
```

## 8. Bottom navigation

```
BottomNavigationBar(
  type: Bottom NavigationBarType.fixed,
  backgroundColor: white, elevation: 0,
  items: [
    BottomNavItem(Home, icon, → home),
    BottomNavItem(Explore, icon, → books),
    BottomNavItem(List +, icon, → /list-a-book),
    BottomNavItem(Activity, icon, → activity),
    BottomNavItem(Profile, avatar, → profile),
  ],
)
```

## 9. Full Assembly (pseudo-code)

```dart
class HomeScreen extends ConsumerState StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final isSignedIn = session != null;
    final initials = _initials(session?.user.userMetadata?['full_name'] as String?);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cream,
      appBar: AppTopBar(
        isSignedIn: isSignedIn,
        avatarInitials: initials,
        onLogin: () => context.go(AppRoute.signIn.path),
        onSignUp: () => context.go(AppRoute.signUp.path),
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SafeArea(
        child: Column(children: [
          _GreetingSection(),
          _SearchBar(),
          _GenresGrid(),
          _AvailableSection(),
          _ExploreAllButton(),
        ]),
      ),
      bottomSheet: _BottomNav(),
    );
  }
}
```

## 10. Token mapping

| Token | Value |
|---|---|
| Scaffold bg | `AppColors.cream` |
| Greeting title | `AppTextStyle.sectionTitle × ink` |
| Search hint | `AppTextStyle.body × inkFaint` |
| Genre label | `AppTextStyle.tileLabel × ink` |
| Card title | `AppTextStyle.cardTitle × brandGreen` |
| Card author | `AppTextStyle.cardAuthor × inkMuted` |
| Owner name | `AppTextStyle.ownerName × ink` |
| Distance badge | green pill, `AppColors.brandGreen`, white text |
| Escrow | `AppColors.ink`, `AppColors.inkMuted` |
| Borrow period | `AppColors.brandGreen` (accent) |
| Card border | `AppColors.cardBorder` 1.w |
| Card radius | `AppRadius.mdAll` |
| Spacing | `Insets.md` between sections |

## 11. Data sources

- `booksViewModelProvider` (AsyncNotifier<List<Book>>) → available books
- `availableGenresProvider` → genre strings
- `currentSessionProvider` → session + signed-in state
- `Book` fields: id, title, author, coverImageUrls, owner (name, avatarUrl, locationText)
- `Rpcs.booksNearby` exists in tables.dart but is unused

## 12. TODOs for the backend

- escrow amount + borrow period are not in the schema → pass `EscrowStat.placeholder`
- ratings are not in the schema → pass `null` to `OwnerRatingRow`
- search bar → `bookSearchProvider`
- bottom nav items → route to their screens
- "List +" → `/list-a-book` (protected route)