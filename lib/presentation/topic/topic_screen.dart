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
        toolbarHeight: topic.title.length * 0.5 + 80,
        title: Column(
            mainAxisSize: MainAxisSize
                .min, // This ensures the column doesn't try to expand in the vertical direction.
            children: [
              Flexible(
                fit: FlexFit
                    .loose, // This allows the text to take as much space as it needs but no more.
                child: Text(
                  topic.title,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                      label: Text(
                    'Questions: ${topic.questionIds.length}',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
                  Chip(
                      label: Text(
                    'Modified: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
                ],
              )
            ]),
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
