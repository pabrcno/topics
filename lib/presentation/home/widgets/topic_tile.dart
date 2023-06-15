import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/home/widgets/topic_tile_menu.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/topic/topic.dart';
import '../../topic/topic_screen.dart';

class TopicTile extends StatelessWidget {
  final Topic topic;

  const TopicTile({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  topic.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TopicTileMenu(topic: topic),
            ],
          )),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${translate('modified')}: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4.0),
        ],
      ),
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
    );
  }
}
