import 'package:flutter/material.dart';

class GamificationService with ChangeNotifier {
  int _dailyMinutes = 0;
  int _streak = 0;
  int _totalPoints = 0;  // Added totalPoints field

  int get dailyMinutes => _dailyMinutes;
  int get currentStreak => _streak;   // renamed getter to match UI
  int get totalPoints => _totalPoints;  // added getter

  void addReadingMinutes(int minutes) {
    _dailyMinutes += minutes;
    _totalPoints += minutes * 2; // Example: 2 points per reading minute
    notifyListeners();
  }

  void checkStreak() {
    // Increase streak if more than 5 minutes read today
    if (_dailyMinutes > 5) {
      _streak += 1;
    } else {
      _streak = 0;
    }
    notifyListeners();
  }

  void resetDailyMinutes() {
    _dailyMinutes = 0;
    notifyListeners();
  }

  String getBadge() {
    if (_totalPoints >= 100) return "🌟 Superstar Reader!";
    if (_streak >= 5) return "🔥 Reading Streak!";
    return "📖 Keep Reading!";
  }
}
