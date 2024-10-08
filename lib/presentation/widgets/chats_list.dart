import 'package:flutter/material.dart';

import '../../../domain/models/chat/chat.dart';
import 'chat_tile.dart';

class ChatsList extends StatelessWidget {
  final List<Chat> chats;

  final Future<void> Function()? onRefresh;

  const ChatsList({
    Key? key,
    required this.chats,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: chats.isEmpty
          ? const Center(
              child: Text('Create a new chat to interact with the AI'),
            )
          : ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: .1,
                  color: Colors.grey.shade100,
                );
              },
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatTile(
                  chat: chat,
                );
              },
            ),
    );
  }
}
