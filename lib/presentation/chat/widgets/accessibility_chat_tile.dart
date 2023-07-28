import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../../../app/tts/tts_provider.dart';
import '../../../domain/models/message/message.dart';

class AccessibilityChatTile extends StatelessWidget {
  final Message message;
  final debouncer = Debouncer(delay: Duration(milliseconds: 500)); // A
  AccessibilityChatTile({
    Key? key,
    required this.message,
  }) : super(key: key);
  void _handleLinkTap(String? href) {
    if (href != null && href.isNotEmpty) {
      if (href.startsWith('http') || href.startsWith('https')) {
        Uri link = Uri.parse(href);
        launchUrl(link);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debouncer.run(() {
      // your action
      Vibration.vibrate(duration: 20);
      final ttsProvider = Provider.of<TTSProvider>(context, listen: false);
      ttsProvider.stop();
      ttsProvider.speak(message.content);
    });
    return GestureDetector(
        onDoubleTap: () {
          final ttsProvider = Provider.of<TTSProvider>(context, listen: false);
          if (ttsProvider.isPlaying) {
            ttsProvider.stop();

            return;
          }
          ttsProvider.speak(message.content);
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.65,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MarkdownBody(
                      onTapText: () {
                        Vibration.vibrate(duration: 100);
                      },
                      fitContent: false,
                      selectable: true,
                      data: message.content,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        blockSpacing: 30,
                        p: const TextStyle(
                          fontSize: 22,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        codeblockPadding: const EdgeInsets.all(8.0),
                        code: const TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            )));
  }
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}

// Using it:
final debouncer =
    Debouncer(delay: Duration(milliseconds: 500)); // Adjust delay as needed
