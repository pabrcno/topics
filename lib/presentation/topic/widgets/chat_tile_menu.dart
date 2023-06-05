import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';

class ChatTileMenu extends StatelessWidget {
  final Chat chat;
  final VoidCallback onDelete;

  const ChatTileMenu({
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
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(color: Colors.red),
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate('cancel')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            value: 'delete',
            child: Text(translate('delete')),
          ),
          PopupMenuItem(
            value: 'changeSummary',
            child: Text(translate('change_summary')),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translate('delete')),
                content: Text(translate('confirm_delete')),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.red),
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(color: Colors.red),
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(translate('cancel')),
                  ),
                  TextButton(
                    child: Text(translate('confirm')),
                    onPressed: () {
                      onDelete();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (value == 'changeSummary') {
          TextEditingController summaryController = TextEditingController();
          _showDialog(
            context,
            Column(
              children: [
                Text(translate('change_summary_chat')),
                TextField(
                  controller: summaryController,
                  decoration:
                      InputDecoration(hintText: translate('new_summary')),
                ),
                TextButton(
                  child: Text(translate('change')),
                  onPressed: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .modifyChatSummary(
                            chat.copyWith(summary: summaryController.text));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
