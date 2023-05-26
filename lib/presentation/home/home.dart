import 'package:flutter/material.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';

import '../../mock_data.dart';
import '../../services/auth_service.dart';
import '../config/configurations.dart';
import 'widgets/topic_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TopicModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/topics_dark_removebg.png',
              height: 35,
            )),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfigurationsPage()),
                );
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      AuthService().getUser()?.photoURL ?? '',
                    ),
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
