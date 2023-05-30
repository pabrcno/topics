import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:topics/presentation/topic/widgets/chats_list.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';

import '../../app/chat/chat_provider.dart';
import '../../domain/models/topic/topic.dart';
import '../widgets/app_chip.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;

  const TopicScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void createNewChat() async {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      await chatProvider.createChat(null, topic);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: topic.title,
        chipsRow: Row(
          children: [
            AppChip(
              label: translate('modified', args: {
                'day': topic.lastModified.day,
                'month': topic.lastModified.month,
                'year': topic.lastModified.year
              }),
            ),
          ],
        ),
      ),
      body: ChatsList(topicId: topic.id),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewChat,
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }
}
