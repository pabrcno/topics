import 'package:flutter/material.dart';

import '../../domain/models/topic/topic.dart';
import 'widgets/topic_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Topic> topics = [
    Topic(
        title: 'Software Architecture and a big name',
        questionsCount: 10,
        lastModified: DateTime.now()),
    Topic(title: 'Topic 2', questionsCount: 5, lastModified: DateTime.now()),
    Topic(title: 'Topic 3', questionsCount: 8, lastModified: DateTime.now()),
  ];

  void _addNewTopic() {
    // Here we might open a dialog or another screen to get the new topic
    // For this example, we'll just add a new topic with a default name
    setState(() {
      topics.add(Topic(
          title: 'Topic ${topics.length + 1}',
          questionsCount: 0,
          lastModified: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics', style: TextStyle(color: Colors.white70)),
      ),
      body: TopicGrid(topics: topics),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTopic,
        tooltip: 'Add Topic',
        child: const Icon(Icons.add),
      ),
    );
  }
}
