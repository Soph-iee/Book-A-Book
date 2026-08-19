import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:book_a_book/src/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notice what this test does *not* need: no Supabase, no `ProviderScope`, no
/// network, no fakes. That is the direct payoff of [BookCard] taking its data
/// through the constructor instead of reading a provider.
void main() {
  setUpAll(() {
    // Otherwise google_fonts tries to fetch Poppins over the network mid-test.
    // Falling back to the bundled default is fine — these assert on text, not
    // on glyphs.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const book = Book(
    id: 1,
    ownerId: 2,
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    genre: 'Science Fiction',
    condition: BookCondition.likeNew,
    owner: BookOwner(id: 2, name: 'Damilola Soyinka'),
  );

  // BookCard reads `.w`/`.h`/`.sp`, which are runtime getters on the
  // initialised ScreenUtil instance — so the widget under test has to sit
  // below a ScreenUtilInit, and it must use `builder` rather than `child`.
  Widget wrap(Widget child) => ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
  );

  testWidgets('renders title, author and owner', (tester) async {
    await tester.pumpWidget(wrap(BookCard(book: book, onTap: () {})));

    expect(find.text('Project Hail Mary'), findsOneWidget);
    expect(find.text('Andy Weir'), findsOneWidget);
    expect(find.text('Damilola Soyinka'), findsOneWidget);
  });

  testWidgets('reports a tap to its caller', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(BookCard(book: book, onTap: () => tapped = true)),
    );

    await tester.tap(find.text('Project Hail Mary'));
    expect(tapped, isTrue);
  });

  testWidgets('renders the location badge only when a location is given', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(BookCard(book: book, onTap: () {})));
    expect(find.text('Bodija'), findsNothing);

    await tester.pumpWidget(
      wrap(BookCard(book: book, onTap: () {}, ownerLocation: 'Bodija')),
    );
    expect(find.text('Bodija'), findsOneWidget);
  });

  testWidgets('shows no rating until one is passed', (tester) async {
    await tester.pumpWidget(wrap(BookCard(book: book, onTap: () {})));
    expect(find.byIcon(Icons.star_rounded), findsNothing);

    await tester.pumpWidget(
      wrap(BookCard(book: book, onTap: () {}, ownerRating: 4.9)),
    );
    expect(find.text('4.9'), findsOneWidget);
  });
}
