import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/home/widgets/topic_card.dart';

import '../../../app/chat/chat_provider.dart';

class TopicGrid extends StatefulWidget {
  const TopicGrid({Key? key}) : super(key: key);

  @override
  _TopicGridState createState() => _TopicGridState();
}

class _TopicGridState extends State<TopicGrid> {
  Future<void> _refreshTopics() async {
    await Provider.of<ChatProvider>(context, listen: false).fetchTopics();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final topics = chatProvider.topics;
        if (topics.isEmpty && chatProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (topics.isEmpty) {
          return Center(child: Text(translate('no_topics_available')));
        } else {
          return RefreshIndicator(
            onRefresh: _refreshTopics,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.only(top: 10),
              children: topics
                  .map((topic) => TopicCard(
                        topic: topic,
                      ))
                  .toList(),
            ),
          );
        }
      },
    );
  }
}
