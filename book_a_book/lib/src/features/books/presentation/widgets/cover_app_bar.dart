import 'package:book_a_book/src/core/router/router_enum.dart';
import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/color.dart';
import '../widgets/book_cover.dart';
import 'scrimmed_icon.dart';

class CoverAppBar extends StatefulWidget {
  const CoverAppBar({super.key, required this.book});

  final Book book;

  @override
  State<CoverAppBar> createState() => _CoverAppBarState();
}

class _CoverAppBarState extends State<CoverAppBar> {
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
      backgroundColor: AppColors.cream,
      leading: ScrimmedIcon(
        icon: Icons.arrow_back,
        tooltip: 'Back',
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(AppRoute.books.path),
      ),
      actions: [
        ScrimmedIcon(
          icon: Icons.share_outlined,
          tooltip: 'Share',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sharing is not wired up yet.')),
          ),
        ),
        Insets.sm.horizontalSpace,
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
