import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  final BookService _bookService = BookService();
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> loadBooks(String readingLevel) async {
    _books = await _bookService.fetchBooksByLevel(readingLevel);
    notifyListeners();
  }
}
