import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../app/chat/chat_provider.dart';
import '../../../app/tts/tts_provider.dart';

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
      finalTimeout: const Duration(seconds: 15),
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
    final ttsProvider = Provider.of<TTSProvider>(context, listen: false);

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final screenSize = MediaQuery.of(context).size;

        return InkWell(
          onLongPress: () {
            if (messageContent.isNotEmpty) {
              _sendMessage(chatProvider);
              return;
            }

            String allInstructions = translate('start_voice_input') +
                '. ' +
                translate('stop_voice_input') +
                '. ' +
                translate('send_voice_message') +
                '. ' +
                translate('listen_to_message') +
                '. ' +
                translate('navigate_chat');

            ttsProvider.speak(allInstructions);
          },
          onTap: messageContent.isEmpty
              ? () {
                  ttsProvider.stop();
                  _startListening(chatProvider);
                }
              : () {
                  final ttsProvider =
                      Provider.of<TTSProvider>(context, listen: false);
                  ttsProvider.stop();
                  ttsProvider.speak(messageContent);
                },
          onDoubleTap: () {
            _speech.stop();
            setState(() => messageContent = '');
          },
          child: SizedBox(
              height: screenSize.height * .15,
              width: screenSize.width,
              child: SingleChildScrollView(
                  child: Column(children: [
                Center(
                  child: Text(
                    messageContent.isEmpty
                        ? translate("tap_to_speak")
                        : messageContent,
                    style: messageContent.isEmpty
                        ? Theme.of(context).textTheme.headlineLarge
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                if (messageContent.isEmpty)
                  Text(translate('long_press_for_instructions'))
              ]))),
        );
      },
    );
  }
}
