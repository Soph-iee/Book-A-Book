import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../domain/book.dart';
import '../view_models/books_view_model.dart';
import '../widgets/borrow_bar.dart';
import '../widgets/book_detail_body.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBook = ref.watch(bookByIdProvider(bookId));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: AsyncValueView<Book>(
        value: asyncBook,
        onRetry: () => ref.invalidate(bookByIdProvider(bookId)),
        builder: (book) => BookDetailBody(book: book),
      ),
      bottomNavigationBar: BorrowBar(book: asyncBook.value),
    );
  }
}
