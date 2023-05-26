import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/mock_data.dart';

import 'package:topics/presentation/topic/widgets/chats_list.dart';
import 'package:topics/presentation/topic/widgets/new_chat_modal.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';

import '../../app/chat/chat_provider.dart';
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
            onSubmit: (initialMessage, topicId) async {
              final chatProvider =
                  Provider.of<ChatProvider>(context, listen: false);

              // Get the current Topic based on topicId
              final currentTopic = topics.firstWhere((t) =>
                  t.id == topicId); // You need to have list of topics in memory
              Navigator.of(context).pop();
              // Create new chat
              chatProvider
                  .createChat(initialMessage, currentTopic)
                  .then((newChat) {
                // Close the NewChatModal dialog
              });
            },
            topicId: topic.id,
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: topic.title,
        chipsRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppChip(
              label:
                  'Modified: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
            ),
          ],
        ),
      ),
      body: ChatsList(chats: chats),
      floatingActionButton: FloatingActionButton(
        onPressed: openModal,
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }
}
