import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/presentation/chat/widgets/chat_app_bar.dart';
import 'package:topics/presentation/chat/widgets/chat_body.dart';
import '../../app/chat/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isAccessibilityMode = false;

  @override
  void initState() {
    super.initState();
    loadAccessibilityMode();
  }

  void loadAccessibilityMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAccessibilityMode = prefs.getBool('isAccessibilityMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatProvider>(context, listen: false).clearChat();
        return true; // return true to allow the pop action to continue
      },
      child: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          return const Scaffold(appBar: ChatAppBar(), body: ChatBody());
        },
      ),
    );
  }
}
