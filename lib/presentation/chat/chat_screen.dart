import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_app_bar.dart';
import 'package:topics/presentation/chat/widgets/chat_body.dart';
import '../../app/chat/chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final bool isNew;

  ChatScreen({Key? key, this.isNew = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatProvider>(context, listen: false).clearChat();
        return true; // return true to allow the pop action to continue
      },
      child: Consumer<ChatProvider>(
          builder: (context, provider, child) =>
              Scaffold(appBar: const ChatAppBar(), body: ChatBody())),
    );
  }
}
