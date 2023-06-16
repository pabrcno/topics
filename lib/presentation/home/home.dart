import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/about/about.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';
import 'package:topics/services/auth/auth_service.dart';

import '../../app/chat/chat_provider.dart';
import '../config/configurations.dart';
import '../store/store_page.dart';
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
    Destination(2, 'Store', Icons.store), // This line is new
  ];
  PageController pageController = PageController(initialPage: 0);
  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<AnimationController> destinationFaders;
  int selectedIndex = 0;
  bool isChipVisible = false;

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
      Provider.of<ChatProvider>(context, listen: false).fetchMessagesCount();
    });
  }

  @override
  void dispose() {
    for (final AnimationController controller in destinationFaders) {
      controller.dispose();
    }
    pageController.dispose();
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
                'assets/images/topics_light_removebg.png',
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
          body: Stack(children: [
            PageView(
              controller: pageController,
              onPageChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: allDestinations.map((Destination destination) {
                switch (destination.index) {
                  case 0:
                    return ChatsList(
                      chats: chatProvider.userChats,
                      onRefresh: () async {
                        await chatProvider.fetchUserChats();
                      },
                    );
                  case 1:
                    return const TopicList();
                  case 2:
                    return const StorePage();
                  default:
                    return Container(); // or some kind of default page
                }
              }).toList(),
            ),
            Positioned(
                left: 0,
                bottom: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.message_outlined),
                    onPressed: () {
                      setState(() {
                        isChipVisible = !isChipVisible;
                      });
                    },
                    label: Text(
                        '${isChipVisible ? translate('messages_left') + ':' : ''} ${chatProvider.userMessageCount}'),
                  ),
                )),
          ]),
          floatingActionButton: selectedIndex != 2
              ? FloatingActionButton(
                  onPressed: () {
                    if (selectedIndex == 0) {
                      chatProvider.createChat(null);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const TopicModal();
                        },
                      );
                    }
                  },
                  tooltip: translate('add_topic'),
                  child: Icon(selectedIndex == 0 ? Icons.chat : Icons.topic),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
              if (pageController.hasClients) {
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);
              }
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
