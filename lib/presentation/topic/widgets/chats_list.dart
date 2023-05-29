import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';
import '../../chat/chat_screen.dart';

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

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onDelete;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                }
              },
            ),
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Created: ${chat.createdAt.day}-${chat.createdAt.month}-${chat.createdAt.year}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4.0),
          Text(
            'Last updated: ${chat.lastModified.day}-${chat.lastModified.month}-${chat.lastModified.year}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chat: chat,
            ),
          ),
        );
      },
    );
  }
}
