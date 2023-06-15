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
          content: Text(translate('confirm_delete_chat')),
          actions: [
            TextButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.red),
                textStyle: MaterialStatePropertyAll(
                  TextStyle(color: Colors.red),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .deleteChat(chat);
                Navigator.of(context).pop();
              },
              child: Text(translate('confirm')),
            ),
          ],
        );
      },
    );
  }

  void _showChangeSummaryDialog(BuildContext context) {
    TextEditingController summaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('change_summary')),
          content: TextField(
            controller: summaryController,
            decoration:
                InputDecoration(hintText: translate('new_summary_hint')),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .modifyChatSummary(
                  chat.copyWith(summary: summaryController.text),
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(translate('delete')),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showDeleteDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(translate('change_summary')),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showChangeSummaryDialog(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
