// lib/utils/text_to_speech_helper.dart
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechHelper {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  TextToSpeechHelper() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
  }

  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await stop();
      return;
    }
    
    _isSpeaking = true;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }
}