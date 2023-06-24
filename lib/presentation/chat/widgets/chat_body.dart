import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_body_base.dart';

import 'package:topics/presentation/chat/widgets/chat_messages_list_view.dart';
import '../../../app/chat/chat_provider.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Column(
        children: <Widget>[
          Flexible(
            child: Stack(
              children: [
                const ChatMessagesListView(),
                Positioned(child: ChatBodyBase()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
