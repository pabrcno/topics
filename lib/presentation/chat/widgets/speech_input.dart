import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:topics/services/permission_service.dart';

class SpeechInput extends StatefulWidget {
  final TextEditingController controller;

  const SpeechInput({Key? key, required this.controller}) : super(key: key);

  @override
  _SpeechInputState createState() => _SpeechInputState();
}

class _SpeechInputState extends State<SpeechInput> {
  final _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: _listen,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.voice_chat,
              color: _isListening ? Colors.red : Colors.grey.shade600),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        finalTimeout: const Duration(seconds: 15),
        onError: (val) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech to text not available: $val'),
            ),
          );
        },
      );
      if (available) {
        if (await permissionServiceProvider.requestMicrophonePermission()) {
          setState(() {
            _isListening = true;
          });
          _speech.listen(
            onResult: (val) {
              setState(() {
                widget.controller.text = val.recognizedWords;
              });
            },
          );
        }
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }
}
