import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';
import 'package:topics/services/auth/auth_service.dart';

import '../config/configurations.dart';
import 'widgets/topic_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _openModal(BuildContext context) {
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
                      AuthService().getCurrentUser()?.photoURL ?? '',
                    ),
                  )))
        ],
      ),
      body: const TopicGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openModal(context),
        tooltip: translate('add_topic'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
