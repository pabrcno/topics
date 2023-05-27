import 'package:flutter/material.dart';

import 'package:topics/presentation/topic/widgets/chats_list.dart';
import 'package:topics/presentation/topic/widgets/new_chat_modal.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';

import '../../domain/models/topic/topic.dart';
import '../widgets/app_chip.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;

  const TopicScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openModal() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return NewChatModal(
            topic: topic,
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: topic.title,
        chipsRow: Row(
          children: [
            AppChip(
              label:
                  'Modified: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
            ),
          ],
        ),
      ),
      body: ChatsList(topicId: topic.id),
      floatingActionButton: FloatingActionButton(
        onPressed: openModal,
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }
}
