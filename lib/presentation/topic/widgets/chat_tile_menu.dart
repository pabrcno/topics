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
      onSelected: (value) async {
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
          String? newSummary = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              String tempSummary = '';
              return AlertDialog(
                title: const Text('Change Summary'),
                content: TextField(
                  onChanged: (value) {
                    tempSummary = value;
                  },
                  decoration:
                      const InputDecoration(hintText: "Enter new summary"),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, tempSummary);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );

          if (newSummary != null) {
            Chat chatWithNewSummary = chat.copyWith(summary: newSummary);
            Provider.of<ChatProvider>(context, listen: false)
                .modifyChatSummary(chatWithNewSummary);
          }
        }
      },
    );
  }
}
