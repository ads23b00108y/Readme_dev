import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  double _ttsSpeed = 1.0;
  String _voiceType = 'female';

  double get ttsSpeed => _ttsSpeed;
  String get voiceType => _voiceType;

  get dyslexiaFont => null;

  get fontSize => null;

  get updateFontSize => null;

  void updateTTSSpeed(double speed) {
  _ttsSpeed = speed;
  notifyListeners();
}

  void setVoiceType(String type) {
    _voiceType = type;
    notifyListeners();
  }

  void setTtsSpeed(double speed) {}

  void toggleDyslexiaFont(bool val) {}
}
