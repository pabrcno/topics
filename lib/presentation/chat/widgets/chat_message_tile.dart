import 'package:flutter/material.dart';

import '../../../domain/models/message/message.dart';

class ChatMessageTile extends StatelessWidget {
  final Message message;

  const ChatMessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Color tileColor = message.isUser
        ? Theme.of(context).hintColor
        : Theme.of(context).highlightColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            '${message.sentAt.hour}:${message.sentAt.minute}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
