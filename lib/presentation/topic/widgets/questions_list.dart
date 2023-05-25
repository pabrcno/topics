import 'package:flutter/material.dart';
import 'package:topics/presentation/chat/chat_screen.dart';

import '../../../domain/models/question/question.dart';

class QuestionsList extends StatelessWidget {
  final List<Question> questions;

  const QuestionsList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: questions.length,
      padding: const EdgeInsets.only(top: 20),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 20,
          thickness: 1,
        );
        // Customize your separator
      },
      itemBuilder: (context, index) {
        final question = questions[index];
        return ListTile(
          title: Text(question.summary.split('\n').take(5).join('\n')),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Chip(
                label: Text(
                  'Created: ${question.createdAt.day}-${question.createdAt.month}-${question.createdAt.year}',
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Chip(
                label: Text(
                    'Last updated: ${question.lastModified.day}-${question.lastModified.month}-${question.lastModified.year}'),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  question: question,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
