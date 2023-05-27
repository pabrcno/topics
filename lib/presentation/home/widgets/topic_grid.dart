import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/home/widgets/topic_card.dart';

import '../../../app/chat/chat_provider.dart';

class TopicGrid extends StatelessWidget {
  const TopicGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final topics = chatProvider.topics;
        if (topics.isEmpty && chatProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (topics.isEmpty) {
          return const Text('No topics available');
        } else {
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.only(top: 10),
            children: topics
                .map((topic) => TopicCard(
                      topic: topic,
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
