import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';

import '../../mock_data.dart';
import '../../services/error_notifier.dart';
import '../config/configurations.dart';
import 'widgets/topic_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addNewTopic(String title) {}

  void _openModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TopicModal(
          onSubmit: (_, __) {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var errorNotifier = Provider.of<ErrorNotifier>(context);

    if (errorNotifier.lastError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('An error occurred')));
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/topics_dark_removebg.png',
          height: 40,
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfigurationsPage()),
                );
              },
              child: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  )))
        ],
      ),
      body: TopicGrid(topics: topics),
      floatingActionButton: FloatingActionButton(
        onPressed: _openModal,
        tooltip: 'Add Topic',
        child: const Icon(Icons.add),
      ),
    );
  }
}
