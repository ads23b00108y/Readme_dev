import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    await _flutterTts.pause(); // May not be supported on all platforms
  }

  // Resume not supported on mobile
  Future<void> resume() async {
    // Optional custom resume logic if needed
    //print("Resume not supported on this platform.");
  }

  //Stream<void> get onComplete => _flutterTts.onComplete!();
}
