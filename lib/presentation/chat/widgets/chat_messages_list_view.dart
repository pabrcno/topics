import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/core/enums.dart';

import '../../../domain/models/message/message.dart';
import 'chat_message_tile.dart';

class ChatMessagesListView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  ChatMessagesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          controller: scrollController,
          itemCount: provider.messages.length +
              (provider.messageBuffer.isNotEmpty ? 1 : 0),
          itemBuilder: (context, index) {
            // Check if there is a new message or an incoming message
            if (index == provider.messages.length) {
              return ChatMessageTile(
                message: Message(
                  content: provider.messageBuffer,
                  id: 'new',
                  chatId: provider.currentChat?.id ?? '',
                  isUser: false,
                  role: EMessageRole.assistant,
                  sentAt: DateTime.now(),
                ),
              );
            } else {
              return ChatMessageTile(message: provider.messages[index]);
            }
          },
        );
      },
    );
  }
}
