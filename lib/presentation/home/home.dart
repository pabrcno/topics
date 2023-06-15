import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/about/about.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';
import 'package:topics/services/auth/auth_service.dart';

import '../../app/chat/chat_provider.dart';
import '../config/configurations.dart';
import '../widgets/chats_list.dart';
import 'widgets/topic_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'Chats', Icons.chat),
    Destination(1, 'Topics', Icons.topic),
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<AnimationController> destinationFaders;
  int selectedIndex = 0;

  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {}); // Rebuild unselected destinations offstage.
      }
    });
    return controller;
  }

  @override
  void initState() {
    super.initState();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
      allDestinations.length,
      (int index) => GlobalKey<NavigatorState>(),
    ).toList();
    destinationFaders = List<AnimationController>.generate(
      allDestinations.length,
      (int index) => buildFaderController(),
    ).toList();
    destinationFaders[selectedIndex].value = 1.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).fetchUserChats();
      Provider.of<ChatProvider>(context, listen: false).fetchTopics();
    });
  }

  @override
  void dispose() {
    for (final AnimationController controller in destinationFaders) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/topics_dark_removebg.png',
                height: 35,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationsPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      AuthService().getCurrentUser()?.photoURL ?? '',
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: allDestinations.map((Destination destination) {
              final int index = destination.index;
              final bool isActive = index == selectedIndex;
              return Offstage(
                offstage: !isActive,
                child: TickerMode(
                    enabled: isActive,
                    child: index == 0
                        ? ChatsList(
                            chats: chatProvider.userChats,
                            onRefresh: () async {
                              await chatProvider.fetchUserChats();
                            },
                          )
                        : const TopicList()),
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return const TopicModal();
              },
            ),
            tooltip: translate('add_topic'),
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: allDestinations.map((Destination destination) {
              return NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.title,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class Destination {
  const Destination(this.index, this.title, this.icon);

  final int index;
  final String title;
  final IconData icon;
}
