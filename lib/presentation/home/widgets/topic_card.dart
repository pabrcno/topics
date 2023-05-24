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
          const EdgeInsets.all(8.0), // Add some margin to separate the cards.
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white70,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0), // Add rounded corners
      ),
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 18.0),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                'Last Modified: ${lastModified.day}-${lastModified.month}-${lastModified.year}',
                style: const TextStyle(color: Colors.white70, fontSize: 12.0),
              ),
              Text(
                'Number of Questions: $questionCount',
                style: const TextStyle(color: Colors.white70, fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
