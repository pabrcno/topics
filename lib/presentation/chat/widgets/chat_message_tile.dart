import 'package:flutter/material.dart';

import '../../../domain/core/enums.dart';
import '../../../domain/models/message/message.dart';

class ChatMessageTile extends StatelessWidget {
  final Message message;

  const ChatMessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: () {
          switch (message.role) {
            case EMessageRole.user:
              return Colors.grey.shade900;

            case EMessageRole.assistant:
              return Colors.cyan.shade900;

            case EMessageRole.system:
              return Colors.yellow.shade900;

            default:
              return Colors
                  .grey; // default color in case none of the roles match
          }
        }(),
        border: Border.all(
          color: Colors.grey.shade800,
          width: .5,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
