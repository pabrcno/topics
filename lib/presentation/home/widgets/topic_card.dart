import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/chat/chat_provider.dart';

import '../../../domain/models/topic/topic.dart';
import '../../topic/topic_screen.dart';
import '../../widgets/app_chip.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicScreen(
              topic: topic,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        topic.title,
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        if (value == 'delete') {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteTopic(topic);
                        }
                      },
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(height: 4),
                AppChip(
                  label:
                      'Modified: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
