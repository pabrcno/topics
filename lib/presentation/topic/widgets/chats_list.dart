import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/chat_screen.dart';

import '../../../app/chat/chat_provider.dart';

class ChatsList extends StatefulWidget {
  final String topicId;

  const ChatsList({super.key, required this.topicId});

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Future<void> _refreshChats() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .fetchChatsForTopic(widget.topicId);
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
              // Customize your separator
            },
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(chat.summary.split('\n').take(5).join('\n'))),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created: ${chat.createdAt.day}-${chat.createdAt.month}-${chat.createdAt.year}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      'Last updated: ${chat.lastModified.day}-${chat.lastModified.month}-${chat.lastModified.year}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
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
            },
          ));
    });
  }
}
