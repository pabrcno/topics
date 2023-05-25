import 'package:flutter/material.dart';
import 'package:topics/mock_data.dart';

import 'package:topics/presentation/topic/widgets/chats_list.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';

import '../../domain/models/topic/topic.dart';
import '../widgets/app_chip.dart';

class TopicScreen extends StatelessWidget {
  final String topicId;

  const TopicScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Topic topic = topics.firstWhere((topic) => topic.id == topicId);
    return Scaffold(
      appBar: CustomAppBar(
        title: topic.title,
        chipsRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppChip(
              label: 'chats: ${topic.chatIds.length}',
            ),
            AppChip(
              label:
                  'Modified: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
            ),
          ],
        ),
      ),
      body: ChatsList(chats: chats),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog or another screen to add a new chat.
        },
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }
}
