import 'package:flutter/material.dart';

import '../../../domain/models/topic/topic.dart';
import 'topic_card.dart';

class TopicGrid extends StatelessWidget {
  final List<Topic>
      topics; // Assuming Topic is a class you have defined with title, lastModified, questionCount as properties.

  const TopicGrid({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: topics
          .map((topic) => TopicCard(
                topicId: topic.id,
                title: topic.title,
                lastModified: topic.lastModified,
              ))
          .toList(),
    );
  }
}
