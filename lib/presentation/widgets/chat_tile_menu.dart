import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';

class ChatTileMenu extends StatelessWidget {
  final Chat chat;

  const ChatTileMenu({
    Key? key,
    required this.chat,
  }) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('delete')),
          content: Text(translate('confirm_delete_topic')),
          actions: [
            TextButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.red),
                textStyle: MaterialStatePropertyAll(
                  TextStyle(color: Colors.red),
                ),
              ),
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .deleteChat(chat);
                Navigator.of(context).pop();
              },
              child: Text(translate('delete')),
            ),
          ],
        );
      },
    );
  }

  void _showChangeSummaryDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('change_title')),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: translate('new_title_hint')),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .modifyChatSummary(
                  chat.copyWith(summary: titleController.text),
                );
                Navigator.of(context).pop();
              },
              child: Text(translate('change')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(translate('change_title')),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showChangeSummaryDialog(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(translate('delete')),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showDeleteDialog(context);
                      },
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
