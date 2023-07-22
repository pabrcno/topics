import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../app/chat/chat_provider.dart';

class AccessibilityInput extends StatefulWidget {
  const AccessibilityInput({super.key});

  @override
  _AccessibilityInputState createState() => _AccessibilityInputState();
}

class _AccessibilityInputState extends State<AccessibilityInput> {
  String messageContent = '';
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> _startListening(ChatProvider chatProvider) async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('STT Status: $status'),
      onError: (error) => print('STT Error: $error'),
      finalTimeout: const Duration(seconds: 5),
    );
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            messageContent = result.recognizedWords;
          });
        },
      );
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
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final screenSize = MediaQuery.of(context).size;

        return InkWell(
          onTap: messageContent.isEmpty
              ? () => _startListening(chatProvider)
              : () => _sendMessage(chatProvider),
          onLongPress: () {
            _speech.stop();
            setState(() => messageContent = '');
          },
          child: SizedBox(
            height: screenSize.height * .15,
            width: screenSize.width,
            child: Center(
              child: Text(
                messageContent.isEmpty ? 'Tap to speak' : messageContent,
                style: messageContent.isEmpty
                    ? Theme.of(context).textTheme.headlineLarge
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
