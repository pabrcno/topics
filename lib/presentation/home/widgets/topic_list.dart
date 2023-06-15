import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/home/widgets/topic_tile.dart';

import '../../../app/chat/chat_provider.dart';

class TopicList extends StatefulWidget {
  const TopicList({Key? key}) : super(key: key);

  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
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
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return TopicTile(topic: topics[index]);
              },
            ),
          );
        }
      },
    );
  }
}
