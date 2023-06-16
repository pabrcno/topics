import 'package:flutter/material.dart';
import 'package:share/share.dart';

class MessageShareButton extends StatelessWidget {
  final String message;

  const MessageShareButton({Key? key, required this.message}) : super(key: key);

  void shareMessage() {
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 15,
        onPressed: () => {shareMessage()},
        icon: const Icon(Icons.share));
  }
}
