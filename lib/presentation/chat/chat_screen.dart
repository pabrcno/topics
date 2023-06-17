import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_app_bar.dart';
import 'package:topics/presentation/chat/widgets/chat_body.dart';
import '../../app/chat/chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final bool isNew;
  ChatScreen({super.key, this.isNew = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
        builder: (context, provider, child) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const ChatAppBar(),
            body: ChatBody()));
  }
}
