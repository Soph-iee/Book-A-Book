# Design specs

These documents describe the Book-A-Book UI in enough detail to build it, but
they contain **no shipped code** — every Dart snippet here is a target to type
by hand, not a file to copy. That is deliberate: see `CLAUDE.md` at the repo
root.

## Where these came from

The only visual source of truth is the Figma export at
`assets/images/iPhone 14 & 15 Pro - 1.png`, a 786×2036 PNG.

**Despite the frame name, that is not a phone design.** Measured text in the
image implies a hero around 30px and book titles around 14.5px; read as a 393pt
phone at @2x those become 15pt and 7.3pt, which nobody ships. It is a ~786px
web/tablet canvas at 1x, and `01-design-system.md` explains what that means in
practice — take its pixel figures at face value as logical pixels, and reflow
the wide rows rather than shrinking them.

The colour palette in `01-design-system.md` was sampled from that PNG rather
than read out of Figma, so it is reproducible: re-run the sampling and you get
the same five hexes. The type scale is a conventional mobile scale that was
cross-checked against measured text runs; it agrees to within a point or two on
the runs that were checked.

Only the home screen was designed in Figma. The auth and book-detail screens are
derived from the design system and from the data the domain models already
carry; both docs say so at the top.

## The documents

| Doc | Covers |
|---|---|
| `01-design-system.md` | `color.dart`, `app_text_style.dart`, spacing, radii, icons, and how they wire into the existing `app_theme.dart` |
| `02-shared-widgets.md` | The recurring-widget catalogue — one widget, one file |
| `03-home-screen.md` | The mockup, section by section |
| `04-auth-screens.md` | Sign in and sign up |
| `05-book-detail-screen.md` | The per-book page and the borrow flow |

Read `01` first. `02` depends on it, and `03`–`05` depend on both.

## Rules that keep this honest

1. **Tokens are never inlined.** No `Color(0xFF...)` and no bare `TextStyle`
   outside `core/theme/`. If a value is not in `AppColors` or `AppTextStyle`, it
   does not belong in a widget — add it to the token file first, so there is
   exactly one place to change it when the design moves.
2. **A widget that appears twice gets its own file.** The catalogue in `02` is
   the list of things the mockup repeats. Building them inline in a screen is
   how the second copy silently drifts from the first.
3. **Every dimension goes through `flutter_screenutil`.** `.w` for widths and
   square shapes, `.h` for vertical rhythm, `.r` for radii, `.sp` for type. A
   raw `16` in a widget is a bug on any screen that is not 393pt wide. The
   corollary in `01`: token files that use these cannot be `const`.
4. **Shared widgets never read providers.** Data in through the constructor,
   events out through callbacks. This is already how
   `features/books/presentation/widgets/book_card.dart` is written, and it is
   what makes those widgets testable without a `ProviderScope` — see
   `test/widget_test.dart`, which constructs a `BookCard` directly.
5. **`core/widgets/` is for genuinely cross-feature widgets only.** Anything
   that serves one feature stays in that feature's `presentation/widgets/`. The
   split is stated per widget in `02` so it is not a judgement call each time.
6. **Deviations from the mockup are written down.** Where these specs depart
   from the Figma file — the carousels in `03`, the split auth screens in `04` —
   the doc says what changed and why. An undocumented deviation is
   indistinguishable from a mistake.
7. **Copy says "Book-A-Book".** The mockup's "BookShare" wordmark is placeholder
   art. The package name, the `MaterialApp.title` in `lib/src/app.dart`, and
   these specs all agree on Book-A-Book.

## What is deliberately not here

- **`assets/svg/` is unused.** Those seven files are not real vectors — each is
  a `<rect>` filled with a `<pattern>` wrapping a base64 PNG, which `flutter_svg`
  renders blank and cannot tint. The specs use built-in Material icons instead
  and add no SVG dependency. `01-design-system.md` carries the mapping and what
  it would take to adopt the SVGs properly.
- **Dark mode.** The mockup is light-only. `app_theme.dart` currently builds a
  `dark()` scheme from a seed; `01` explains what to do with it in the interim
  rather than inventing a dark palette nobody has designed.
- **The escrow/payment integration.** `05` specs the borrow *action* against the
  repository method that already exists. Money movement is out of scope.
