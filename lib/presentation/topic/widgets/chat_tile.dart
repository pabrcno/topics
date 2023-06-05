import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:topics/presentation/topic/widgets/chat_tile_menu.dart';

import '../../../domain/models/chat/chat.dart';
import '../../chat/chat_screen.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onDelete;

  const ChatTile({
    Key? key,
    required this.chat,
    required this.onDelete,
  }) : super(key: key);

  void _showDialog(BuildContext context, Widget content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3),
              child: content,
            ),
          ),
          actions: [
            TextButton(
              child: Text(translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            ChatTileMenu(chat: chat, onDelete: onDelete),
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
