import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';
import 'chat_tile.dart';

class ChatsList extends StatefulWidget {
  final String topicId;

  const ChatsList({Key? key, required this.topicId}) : super(key: key);

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Future<void> _refreshChats() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .fetchChatsForTopic(widget.topicId);
  }

  void _deleteChat(Chat chat) {
    Provider.of<ChatProvider>(context, listen: false).deleteChat(chat);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, provider, child) {
      final chats = provider.currentTopicChats;
      return RefreshIndicator(
        onRefresh: _refreshChats,
        child: ListView.separated(
          itemCount: chats.length,
          padding: const EdgeInsets.only(top: 20),
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: .8,
              color: Colors.grey.shade800,
            );
          },
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatTile(
              chat: chat,
              onDelete: () {
                _deleteChat(chat);
              },
            );
          },
        ),
      );
    });
  }
}
