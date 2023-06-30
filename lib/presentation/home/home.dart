import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_app_bar.dart';
import 'package:topics/presentation/chat/widgets/chat_body.dart';
import 'package:topics/presentation/home/widgets/topic_modal.dart';

import '../../app/chat/chat_provider.dart';

import '../../app/store/store_provider.dart';
import '../../app/theme/theme_provider.dart';
import '../about/about.dart';
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
    Destination(0, '', Icons.chat),
    Destination(1, '', Icons.history),
    Destination(2, '', Icons.topic),
    Destination(3, '', Icons.store),
    Destination(4, '', Icons.settings),
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
    return WillPopScope(onWillPop: () async {
      return false;
    }, child: Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: selectedIndex == 0
              ? const ChatAppBar()
              : AppBar(
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
                      Provider.of<ThemeProvider>(context).logoUrl,
                    ),
                  ),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(children: [
                          const Icon(Icons.message_outlined),
                          Text(
                              ' ${chatProvider.userMessageCount + Provider.of<StoreProvider>(context).userMessageCount}'),
                        ])),
                  ],
                ),
          body: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: allDestinations.map((Destination destination) {
              switch (destination.index) {
                case 0:
                  return const ChatBody();
                case 1:
                  return ChatsList(
                    chats: chatProvider.userChats,
                    onRefresh: () async {
                      await chatProvider.fetchUserChats();
                    },
                  );
                case 2:
                  return const TopicList();
                case 3:
                  return const StorePage();
                case 4:
                  return const ConfigurationsPage();
                default:
                  return Container(); // or some kind of default page
              }
            }).toList(),
          ),
          floatingActionButton: selectedIndex != 3 &&
                  selectedIndex != 0 &&
                  selectedIndex != 4
              ? FloatingActionButton(
                  onPressed: () {
                    if (selectedIndex == 1) {
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
                  child: Icon(selectedIndex == 1 ? Icons.chat : Icons.topic),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            height: 55,
            elevation: 0,
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
                icon: Icon(destination.icon, size: 20),
                label: destination.title,
              );
            }).toList(),
          ),
        );
      },
    ));
  }
}

class Destination {
  const Destination(this.index, this.title, this.icon);

  final int index;
  final String title;
  final IconData icon;
}
