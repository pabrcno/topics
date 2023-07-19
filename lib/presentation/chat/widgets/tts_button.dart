import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/tts/tts_provider.dart';

class TTSButton extends StatelessWidget {
  final String text;

  const TTSButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ttsProvider = Provider.of<TTSProvider>(context);
    return IconButton(
      icon: Icon(ttsProvider.isPlaying ? Icons.stop : Icons.volume_up,
          color: ttsProvider.isPlaying
              ? Colors.yellow.shade900
              : Theme.of(context).colorScheme.primary),
      tooltip: 'Click to speak',
      onPressed: ttsProvider.isPlaying
          ? () => ttsProvider.stop()
          : () => ttsProvider.speak(text),
    );
  }
}
