import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:flutter/material.dart';

class TTSProvider with ChangeNotifier {
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  late FlutterTts flutterTts;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  TTSProvider() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      _isPlaying = true;
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      notifyListeners();
    });

    flutterTts.setCancelHandler(() {
      _isPlaying = false;
      notifyListeners();
    });

    flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
      notifyListeners();
    });
  }
  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> speak(String text) async {
    // Identify the language of the text.
    final result = await languageIdentifier
        .identifyLanguage(text.length >= 100 ? text.substring(0, 100) : text);
    final String language = result;
    if (await flutterTts.isLanguageAvailable(language)) {
      await flutterTts.setLanguage(language);
    } else {
      // If the detected language is not available, default to English.
      await flutterTts.setLanguage("en-US");
    }
    _isPlaying = true;
    notifyListeners();

    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    languageIdentifier.close();
    super.dispose();
  }
}
