import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/core/enums.dart';
import '../../../domain/models/chat/chat.dart';
import '../../../domain/models/message/message.dart';
import 'chat_message_tile.dart';

class ChatMessagesListView extends StatefulWidget {
  final Chat chat;
  final bool isNew;

  const ChatMessagesListView(
      {super.key, required this.chat, this.isNew = false});

  @override
  _ChatMessagesListViewState createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isNew) {
        Provider.of<ChatProvider>(context, listen: false)
            .setCurrentChat(widget.chat);
      }
    });
  }

  // Rest of your code...

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          if (scrollController.hasClients &&
              provider.messages.isNotEmpty &&
              scrollController.positions.isNotEmpty) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          }
        });
        return provider.isLoading && provider.messages.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: scrollController,
                itemCount: provider.messages.length +
                    (provider.messageBuffer.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  // Check if there is a new message or an incoming message
                  if (index == provider.messages.length) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(
                          scrollController.position.maxScrollExtent,
                        );
                      }
                    });

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
