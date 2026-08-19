import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// The root widget. Deliberately tiny: it wires theme and router together and
/// nothing else, so `main.dart` stays a bootstrap file and this stays readable.
class BookABookApp extends ConsumerWidget {
  const BookABookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      // Must match the mockup's frame or every figure in `docs/design/` is
      // wrong.
      designSize: const Size(393, 852),
      minTextAdapt: true,
      // `builder`, not `child`. A `child:` is constructed *before*
      // ScreenUtilInit builds, so `AppTheme.light()` — which reads `.sp` and
      // `.r` — would run against an uninitialised ScreenUtil and silently
      // produce unscaled values.
      builder: (context, _) => MaterialApp.router(
        title: 'Book-A-Book',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        // The mockup is light-only, and `dark()` returns `light()`. Shipping
        // one correct theme beats shipping a half-guessed second one.
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}
