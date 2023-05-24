import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {
  final String title;
  final DateTime lastModified;
  final int questionCount;

  const TopicCard(
      {super.key,
      required this.title,
      required this.lastModified,
      required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.all(1.0), // Add some margin to separate the cards.

      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                'Last Modified: ${lastModified.day}-${lastModified.month}-${lastModified.year}',
              ),
              Text(
                'Number of Questions: $questionCount',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
