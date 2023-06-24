import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';

import '../chat/chat_screen.dart';
import 'chat_tile_menu.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;

  const ChatTile({
    Key? key,
    required this.chat,
  }) : super(key: key);

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
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ChatTileMenu(
              chat: chat,
            ),
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${translate('created')} ${chat.createdAt.day}/${chat.createdAt.month}/${chat.createdAt.year}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4.0),
          Text(
            translate(
                '${translate('last_updated')} ${chat.lastModified.day}/${chat.lastModified.month}/${chat.lastModified.year}'),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      onTap: () {
        final provider = Provider.of<ChatProvider>(context, listen: false);
        provider.currentChat = chat;
        provider.fetchMessages();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
            // Set fullscreenDialog to true
          ),
        );
      },
    );
  }
}
