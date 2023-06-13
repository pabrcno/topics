import 'package:flutter/material.dart';
import 'package:topics/presentation/chat/widgets/message_share_button.dart';
import '../../../domain/core/enums.dart';
import '../../../domain/models/message/message.dart';

// Don't forget to import your MessageShareButton

class ChatMessageTile extends StatelessWidget {
  final Message message;

  const ChatMessageTile({Key? key, required this.message}) : super(key: key);

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
              return Colors.grey.shade800;

            case EMessageRole.system:
              return Colors.grey;

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
          SelectableText(
            message.content,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${message.sentAt.hour}:${message.sentAt.minute}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                MessageShareButton(message: message.content),
              ],
            ),
          )
        ],
      ),
    );
  }
}
