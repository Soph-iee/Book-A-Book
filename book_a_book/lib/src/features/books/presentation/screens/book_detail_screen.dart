import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/buttons.dart';
import '../../data/sample_books.dart';
import '../../domain/book.dart';
import '../widgets/book_cover.dart';
import '../widgets/escrow_stat.dart';
import '../widgets/owner_rating_row.dart';

/// The per-book page, reached by tapping a [BookCard].
///
/// This is the one screen where a `CustomScrollView` earns its keep: the cover
/// collapses into the app bar as you scroll.
///
/// TODO(backend): becomes a `ConsumerWidget` wrapping the body in
///   AsyncValueView(value: ref.watch(bookByIdProvider(bookId)), builder: ...)
/// `bookByIdProvider` was written for this screen and is currently referenced
/// by nothing. `fetchById` selects with the `_withOwner` embed, so `book.owner`
/// is populated, and `.single()` throws PGRST116 for a missing row, which
/// `SupabaseAdapter` maps to `NotFoundFailure` — so a bad `:id` already has a
/// defined outcome that `AppErrorView` renders.
class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final int bookId;

  @override
  Widget build(BuildContext context) {
    final entry = sampleBookById(bookId);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const AppErrorView(error: NotFoundFailure()),
      );
    }

    final book = entry.book;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _CoverAppBar(book: book),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Insets.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleBlock(book: book),
                  SizedBox(height: Insets.lg),
                  // `book.owner` is nullable. Hide the whole card rather than
                  // rendering "null" — a book whose owner row was deleted
                  // should still be readable.
                  if (book.owner != null) ...[
                    _OwnerCard(
                      owner: book.owner!,
                      location: entry.ownerLocation,
                    ),
                    SizedBox(height: Insets.lg),
                  ],
                  // Skip each section entirely when its field is null. Never
                  // render an empty heading.
                  if (book.aiSummary != null) ...[
                    _Prose(
                      heading: 'About this book',
                      body: book.aiSummary!,
                      aiGenerated: true,
                    ),
                    SizedBox(height: Insets.lg),
                  ],
                  if (book.whyRead != null) ...[
                    _Prose(
                      heading: 'Why read it',
                      body: book.whyRead!,
                      aiGenerated: true,
                    ),
                    SizedBox(height: Insets.lg),
                  ],
                  if (book.tags.isNotEmpty) _Tags(tags: book.tags),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BorrowBar(book: book),
    );
  }
}

// ------------------------------------------------------------- 1 · Cover

class _CoverAppBar extends StatefulWidget {
  const _CoverAppBar({required this.book});

  final Book book;

  @override
  State<_CoverAppBar> createState() => _CoverAppBarState();
}

class _CoverAppBarState extends State<_CoverAppBar> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.book.coverImageUrls;
    final expandedHeight = 320.h;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      // Book covers have wildly different aspect ratios and BoxFit.contain
      // letterboxes most of them. Cream letterboxing looks intentional; white
      // looks broken *(chosen)*.
      backgroundColor: AppColors.cream,
      // Without a scrim these vanish against a light cover.
      leading: _ScrimmedIcon(
        icon: Icons.arrow_back,
        tooltip: 'Back',
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(AppRoute.books.path),
      ),
      actions: [
        _ScrimmedIcon(
          icon: Icons.share_outlined,
          tooltip: 'Share',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sharing is not wired up yet.')),
          ),
        ),
        SizedBox(width: Insets.sm),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ColoredBox(
          color: AppColors.cream,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (urls.length > 1)
                PageView.builder(
                  controller: _controller,
                  itemCount: urls.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) => BookCover(
                    imageUrl: urls[i],
                    width: double.infinity,
                    height: expandedHeight,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.zero,
                  ),
                )
              else
                // With no entries at all, BookCover's own fallback draws the
                // cream placeholder and the book icon.
                BookCover(
                  imageUrl: widget.book.primaryCoverUrl,
                  width: double.infinity,
                  height: expandedHeight,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.zero,
                ),
              if (urls.length > 1)
                Padding(
                  padding: EdgeInsets.only(bottom: Insets.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < urls.length; i++)
                        Container(
                          width: 6.w,
                          height: 6.w,
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _page
                                ? AppColors.brandGreen
                                : AppColors.inkFaint,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrimmedIcon extends StatelessWidget {
  const _ScrimmedIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scrim,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, size: 20.w, color: AppColors.white),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// ------------------------------------------------------- 2 · Title block

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.heroTitle.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: Insets.xs),
        Text(
          book.author,
          style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
        ),
        SizedBox(height: Insets.md),
        Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            // Both enums already carry their display string
            // (`likeNew('like_new', 'Like new')`), so there is no switch here
            // and no `.name` — a second mapping is a second thing to keep in
            // sync when a case is added.
            //
            // The status chip is the loud one: it is the single fact that gates
            // the CTA.
            _Chip(label: book.status.label, filled: book.isAvailable),
            _Chip(label: book.condition.label),
            // `genre` is free text and nullable.
            if (book.genre != null && book.genre!.isNotEmpty)
              _Chip(label: book.genre!),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.filled = false, this.onTap});

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: filled ? AppColors.brandGreen : AppColors.cream,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: AppTextStyle.statLabel.copyWith(
          color: filled ? AppColors.white : AppColors.ink,
        ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}

// ------------------------------------------------------------ 3 · Owner

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner, this.location});

  final BookOwner owner;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerRatingRow(
            name: owner.name,
            avatarUrl: owner.avatarUrl,
            // No rating column exists in the schema yet.
            rating: null,
            avatarSize: 40,
          ),
          if (location != null) ...[
            SizedBox(height: Insets.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.w,
                  color: AppColors.inkMuted,
                ),
                SizedBox(width: Insets.xs),
                Text(
                  location!,
                  style: AppTextStyle.statLabel.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: Insets.md),
          // TODO(backend): route to this owner's other books —
          // `BooksRepository.fetchByOwner(ownerId)` already exists to feed it.
          SecondaryButton(
            label: 'View shelf',
            expand: true,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shelves are not wired up yet.')),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------- 4 · About / Why read it

class _Prose extends StatelessWidget {
  const _Prose({
    required this.heading,
    required this.body,
    this.aiGenerated = false,
  });

  final String heading;
  final String body;
  final bool aiGenerated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: Insets.sm),
        Text(body, style: AppTextStyle.body.copyWith(color: AppColors.ink)),
        // Presenting machine-written blurb as though it were publisher copy is
        // much easier to disclose now than to retrofit after someone complains
        // *(chosen)*.
        if (aiGenerated) ...[
          SizedBox(height: Insets.xs),
          Text(
            'Summary generated by AI',
            style: AppTextStyle.statLabel.copyWith(color: AppColors.inkFaint),
          ),
        ],
      ],
    );
  }
}

// ------------------------------------------------------------- 5 · Tags

class _Tags extends StatelessWidget {
  const _Tags({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: Insets.sm),
        Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            for (final tag in tags)
              // TODO(backend): route to search with the tag as the query.
              // `BooksRepository.search()` covers title and author but not
              // tags — either widen the `.or()` filter or accept that a tag
              // search returns title/author matches.
              _Chip(
                label: tag,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tag search is not wired up yet.'),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ------------------------------------------------------- 6 · Borrow bar

/// Pinned rather than scrolled-to: on a long page the primary action must never
/// be below the fold.
class _BorrowBar extends StatelessWidget {
  const _BorrowBar({required this.book});

  final Book book;

  /// The button is not always "Borrow this book".
  ///
  /// TODO(backend): the owner case needs the current *profile*, not the
  /// session. `currentUserIdProvider` returns the Supabase auth uid (a String
  /// uuid) while `Book.ownerId` is an int referencing `profiles.id` — they are
  /// not the same key, and `ProfileRepository.fetchCurrent()` bridges them.
  /// Getting this wrong lets people try to borrow their own books, which the
  /// RPC rejects anyway, but with a confusing error instead of a disabled
  /// button.
  (String label, bool enabled) get _cta => switch (book.status) {
    BookStatus.available => ('Borrow this book', true),
    BookStatus.requested => ('Requested', false),
    BookStatus.borrowed => ('Currently borrowed', false),
  };

  @override
  Widget build(BuildContext context) {
    final (label, enabled) = _cta;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.md),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const EscrowStat(
                      value: EscrowStat.placeholder,
                      label: 'escrow',
                    ),
                    SizedBox(width: Insets.md),
                    const Flexible(
                      child: EscrowStat(
                        value: EscrowStat.placeholder,
                        label: 'borrow period',
                        accent: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Insets.md),
              PrimaryButton(
                label: label,
                onPressed: enabled ? () => _confirmBorrow(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Borrowing takes money; it does not happen on a single tap *(chosen)*.
  ///
  /// TODO(backend): the full sequence is
  ///   1. signed out → `context.go('/sign-in')` — the auth wall lives on the
  ///      action, not the route;
  ///   2. confirm here;
  ///   3. `ref.read(borrowControllerProvider.notifier).borrow(book.id)` — a
  ///      *command-only* controller, not `BooksController.borrow`, which puts
  ///      the list controller into a loading state and makes the home carousel
  ///      flash a spinner while you borrow;
  ///   4. that controller invalidates both `bookByIdProvider(bookId)` and
  ///      `booksControllerProvider`, because the RPC changed a row both are
  ///      showing and neither refetches on its own;
  ///   5. failures go through `ref.listen` + SnackBar, switching over the
  ///      sealed `Failure` hierarchy — `DatabaseFailure` is the lost race, and
  ///      "Someone just borrowed this one. Try another." beats "database
  ///      error".
  void _confirmBorrow(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Borrow this book?',
                style: AppTextStyle.sectionTitle.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: Insets.sm),
              Text(
                book.title,
                style: AppTextStyle.cardTitle.copyWith(
                  color: AppColors.brandGreen,
                ),
              ),
              SizedBox(height: Insets.md),
              Row(
                children: [
                  const EscrowStat(
                    value: EscrowStat.placeholder,
                    label: 'escrow',
                  ),
                  SizedBox(width: Insets.xl),
                  const EscrowStat(
                    value: EscrowStat.placeholder,
                    label: 'borrow period',
                    accent: true,
                  ),
                ],
              ),
              SizedBox(height: Insets.md),
              Text(
                'Your escrow is refundable when you return the book in good '
                'condition.',
                style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
              ),
              SizedBox(height: Insets.lg),
              PrimaryButton(
                label: 'Confirm and pay escrow',
                expand: true,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Borrowing is not wired up yet.'),
                    ),
                  );
                },
              ),
              SizedBox(height: Insets.sm),
              SecondaryButton(
                label: 'Cancel',
                expand: true,
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
