import 'package:flutter/material.dart';
import 'package:topics/mock_data.dart';

import 'package:topics/presentation/topic/widgets/questions_list.dart';

import '../../domain/models/topic/topic.dart';

class TopicScreen extends StatelessWidget {
  final String topicId;

  const TopicScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Topic topic = topics.firstWhere((topic) => topic.id == topicId);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: topic.title.length * 0.5 + 50,
        title: Expanded(
          child: Text(
            topic.title,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        elevation: 0.8,
        shadowColor: Colors.grey[700],
      ),
      body: QuestionsList(questions: questions),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog or another screen to add a new question.
        },
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }
}
