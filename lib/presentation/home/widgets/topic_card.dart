import 'package:flutter/material.dart';

import '../../topic/topic_screen.dart';
import '../../widgets/app_chip.dart';

class TopicCard extends StatelessWidget {
  final String topicId;
  final String title;
  final DateTime lastModified;
  final int questionCount;

  const TopicCard(
      {Key? key,
      required this.topicId,
      required this.title,
      required this.lastModified,
      required this.questionCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicScreen(
              topicId: topicId,
            ),
          ),
        );
      },
      child: Container(
        margin:
            const EdgeInsets.all(1.0), // Add some margin to separate the cards.
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                AppChip(
                  label: 'Chats: $questionCount',
                ),
                const SizedBox(height: 4),
                AppChip(
                  label:
                      'Modified: ${lastModified.day}-${lastModified.month}-${lastModified.year}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
