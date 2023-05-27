import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/core/enums.dart';
import '../../../domain/models/chat/chat.dart';
import '../../../domain/models/message/message.dart';
import 'chat_message_tile.dart';

class ChatMessagesListView extends StatefulWidget {
  final ScrollController scrollController;
  final Chat chat;
  final bool isNew;

  const ChatMessagesListView(
      {super.key,
      required this.scrollController,
      required this.chat,
      this.isNew = false});

  @override
  _ChatMessagesListViewState createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isNew) {
        return;
      }
      Provider.of<ChatProvider>(context, listen: false)
          .setCurrentChat(widget.chat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return provider.isLoading && provider.messages.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: widget.scrollController,
                itemCount: provider.messages.length +
                    (provider.messageBuffer.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
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
