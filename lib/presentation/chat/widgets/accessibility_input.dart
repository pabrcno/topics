import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:topics/app/tts/tts_provider.dart';
import '../../../app/chat/chat_provider.dart';

class AccessibilityInput extends StatefulWidget {
  const AccessibilityInput({super.key});

  @override
  _AccessibilityInputState createState() => _AccessibilityInputState();
}

class _AccessibilityInputState extends State<AccessibilityInput> {
  String messageContent = '';
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('STT Status: $status'),
      onError: (error) => print('STT Error: $error'),
    );
    if (available) {
      _speech.listen(onResult: (result) {
        setState(() {
          messageContent = result.recognizedWords;
        });
      });
    }
  }

  Future<void> _stopListening() async {
    _speech.stop();
  }

  void _sendMessage(ChatProvider chatProvider) {
    chatProvider.sendMessage(messageContent);
    setState(() => messageContent = '');
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;

    final ttsProvider = Provider.of<TTSProvider>(context);

    ttsProvider.speak(translate("tap_to_speak"));
    return InkWell(
      onTap: messageContent.isEmpty ? _startListening : _stopListening,
      onDoubleTap: () => _sendMessage(chatProvider),
      child: Container(
        height: screenSize.height * 0.15,
        width: screenSize.width,
        color: Colors.grey[300],
        child: Center(
          child:
              Text(messageContent.isEmpty ? 'Tap to speak...' : messageContent),
        ),
      ),
    );
  }
}
