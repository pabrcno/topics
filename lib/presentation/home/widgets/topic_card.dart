import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/topic/topic.dart';
import '../../topic/topic_screen.dart';
import '../../widgets/app_chip.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({
    Key? key,
    required this.topic,
  }) : super(key: key);

  void _showDialog(BuildContext context, Widget content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: content,
            ),
          ),
          actions: [
            TextButton(
              child: Text(translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        margin: const EdgeInsets.all(1.0),
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
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(translate('delete')),
                          ),
                          PopupMenuItem<String>(
                            value: 'changeTitle',
                            child: Text(translate('change_title')),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        if (value == 'delete') {
                          _showDialog(context,
                              Text(translate('are_you_sure_delete_topic')));
                        } else if (value == 'changeTitle') {
                          TextEditingController titleController =
                              TextEditingController();
                          _showDialog(
                            context,
                            Column(
                              children: [
                                Text(translate('change_title_of_topic')),
                                TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      hintText: translate('new_title')),
                                ),
                                TextButton(
                                  child: Text(translate('change')),
                                  onPressed: () {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .modifyTopicTitle(topic.copyWith(
                                            title: titleController.text));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(height: 4),
                AppChip(
                  label:
                      '${translate('modified')}: ${topic.lastModified.day}-${topic.lastModified.month}-${topic.lastModified.year}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
