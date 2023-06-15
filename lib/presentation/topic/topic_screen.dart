import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:topics/presentation/widgets/custom_app_bar.dart';

import '../../app/chat/chat_provider.dart';
import '../../domain/models/topic/topic.dart';
import '../widgets/app_chip.dart';
import '../widgets/chats_list.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;

  const TopicScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
        builder: (context, provider, child) => Scaffold(
              appBar: CustomAppBar(
                title: topic.title,
                chipsRow: Row(
                  children: [
                    AppChip(
                      label:
                          '${translate('modified')}: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
                    ),
                  ],
                ),
              ),
              body: ChatsList(
                chats: provider.currentTopicChats,
                onRefresh: () async {
                  provider.fetchChatsForTopic(topic.id);
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => provider.createChat(null, topic),
                child: const Icon(Icons.messenger_outline),
              ),
            ));
  }
}
