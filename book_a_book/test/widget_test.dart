import 'package:book_a_book/src/features/books/domain/book.dart';
import 'package:book_a_book/src/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Notice what this test does *not* need: no Supabase, no `ProviderScope`, no
/// network, no fakes. That is the direct payoff of [BookCard] taking its data
/// through the constructor instead of reading a provider.
void main() {
  const book = Book(
    id: 1,
    ownerId: 2,
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    genre: 'Science Fiction',
    condition: BookCondition.likeNew,
  );

  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  testWidgets('renders title, author and condition', (tester) async {
    await tester.pumpWidget(wrap(const BookCard(book: book)));

    expect(find.text('Project Hail Mary'), findsOneWidget);
    expect(find.text('Andy Weir'), findsOneWidget);
    expect(find.text('Like new'), findsOneWidget);
  });

  testWidgets('reports a borrow request to its caller', (tester) async {
    var requested = false;

    await tester.pumpWidget(
      wrap(BookCard(book: book, onBorrow: () => requested = true)),
    );

    await tester.tap(find.text('Request'));
    expect(requested, isTrue);
  });

  testWidgets('hides the request button when the book is unavailable',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        BookCard(
          book: book.copyWith(status: BookStatus.borrowed),
          onBorrow: () {},
        ),
      ),
    );

    expect(find.text('Request'), findsNothing);
  });
}
