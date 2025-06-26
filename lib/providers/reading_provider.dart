import 'package:flutter/material.dart';

class ReadingProvider with ChangeNotifier {
  int _currentPage = 0;
  List<String> _pages = [];

  int get currentPage => _currentPage;
  List<String> get pages => _pages;

  void loadBook(String fullText) {
    _pages = _paginateText(fullText);
    _currentPage = 0;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  List<String> _paginateText(String text) {
    const int charsPerPage = 500;
    List<String> chunks = [];
    for (int i = 0; i < text.length; i += charsPerPage) {
      chunks.add(text.substring(i, i + charsPerPage > text.length ? text.length : i + charsPerPage));
    }
    return chunks;
  }
}
