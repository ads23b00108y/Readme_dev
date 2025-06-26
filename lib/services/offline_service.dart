import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineService {
  static const String _bookKeyPrefix = 'offline_book_';
  static const String _progressKeyPrefix = 'reading_progress_';

  Future<void> saveBook(String bookId, String content) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookKeyPrefix + bookId, content);
  }

  Future<String?> getBook(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bookKeyPrefix + bookId);
  }

  Future<void> saveReadingProgress(String childId, String bookId, int page, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final progressKey = '$_progressKeyPrefix${childId}_$bookId';
    Map<String, dynamic> data = {
      'page': page,
      'timeSpent': minutes,
    };
    await prefs.setString(progressKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getReadingProgress(String childId, String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_progressKeyPrefix${childId}_$bookId');
    return data != null ? jsonDecode(data) : null;
  }
}
