import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';
import '../../config/configurations.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return AppBar(
          title: GestureDetector(
            onTap: () async {
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
                Chat? chatWithNewSummary =
                    chatProvider.currentChat?.copyWith(summary: newSummary);
                if (chatWithNewSummary != null) {
                  await chatProvider.modifyChatSummary(chatWithNewSummary);
                }
              }
            },
            child: Row(children: [
              Expanded(
                  child: Text(
                chatProvider.currentChat!.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
              const Icon(
                Icons.edit,
                size: 20,
              )
            ]),
          ),
          actions: [
            IconButton(
              onPressed: () {
                chatProvider.clearChat();
              },
              icon: Icon(
                Icons.cleaning_services_rounded,
                color: Colors.yellow.shade900,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: [
                  const Icon(Icons.message_outlined),
                  Text(' ${chatProvider.userMessageCount}'),
                ])),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfigurationsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}
