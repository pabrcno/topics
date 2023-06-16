import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class TTSButton extends StatefulWidget {
  final String text;

  TTSButton({required this.text});

  @override
  _TTSButtonState createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton> {
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _speak() async {
    // Identify the language of the text.
    final result = await languageIdentifier.identifyLanguage(widget.text);
    final String language = result;
    if (await flutterTts.isLanguageAvailable(language)) {
      await flutterTts.setLanguage(language);
    } else {
      // If the detected language is not available, default to English.
      await flutterTts.setLanguage("en-US");
    }
    setState(() {
      isPlaying = true;
    });
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(widget.text);
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    languageIdentifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.stop : Icons.volume_up,
          color: isPlaying
              ? Colors.yellow.shade900
              : Theme.of(context).primaryColor),
      tooltip: 'Click to speak',
      onPressed: isPlaying ? _stop : _speak,
    );
  }
}
