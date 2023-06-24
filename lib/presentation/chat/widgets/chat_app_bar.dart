import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';

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
          actions: chatProvider.messages.isNotEmpty
              ? [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(translate('clear_chat')),
                            content: Text(translate('clear_chat_description')),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  chatProvider.clearChat();
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text(translate('confirm')),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.cleaning_services_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(translate('add_to_topic')),
                            children: chatProvider.topics.map((topic) {
                              return SimpleDialogOption(
                                  onPressed: () async {
                                    chatProvider.changeChatTopicId(
                                        topic.id, null);
                                    Navigator.pop(context, topic.title);
                                  },
                                  child: Column(children: [
                                    ListTile(
                                      leading: const Icon(Icons.topic_outlined),
                                      title: Text(topic.title),
                                      dense: true,
                                    ),
                                    const Divider()
                                  ]));
                            }).toList(),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.topic_outlined),
                  )
                ]
              : null,
        );
      },
    );
  }
}
