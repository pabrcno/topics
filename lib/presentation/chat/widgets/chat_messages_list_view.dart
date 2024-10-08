import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/services/auth/auth_service.dart';

import '../../../app/chat/chat_provider.dart';

import '../../../domain/core/enums.dart';
import '../../../domain/models/message/message.dart';
import '../../widgets/animated_logo.dart';
import 'chat_message_tile.dart';

class ChatMessagesListView extends StatefulWidget {
  const ChatMessagesListView({Key? key}) : super(key: key);

  @override
  _ChatMessagesListViewState createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  final ScrollController _scrollController = ScrollController();
  final user = AuthService().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(const Duration(milliseconds: 200));
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
          }
        });

        if (provider.messages.isEmpty && provider.messageBuffer.isEmpty) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    Opacity(
                      opacity: provider.chatModel == EModel.gpt3.stringValue
                          ? 1
                          : 0.5,
                      child: FilledButton(
                          onPressed: () {
                            provider.setChatModel(EModel.gpt3.stringValue);
                          },
                          child: Text(EModel.gpt3.stringValue.toUpperCase())),
                    ),
                    Opacity(
                      opacity: provider.chatModel == EModel.gpt4.stringValue
                          ? 1
                          : 0.5,
                      child: FilledButton(
                          onPressed: () {
                            provider.setChatModel(EModel.gpt4.stringValue);
                          },
                          child: Text(EModel.gpt4.stringValue.toUpperCase())),
                    ),
                  ],
                ),
                Opacity(
                    opacity: .8,
                    child: SizedBox(
                      height: 150,
                      child: AnimatedLogo(), // path to your logo image
                    )),
                SizedBox()
              ]);
        } else {
          return Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                controller: _scrollController,
                itemCount: provider.messages.length +
                    (provider.messageBuffer.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.messages.length) {
                    return ChatMessageTile(
                      userImage: user?.photoURL ?? '',
                      userName: user?.displayName ?? '',
                      message: Message(
                        content: provider.messageBuffer,
                        id: 'new',
                        chatId: provider.currentChat?.id ?? '',
                        isUser: false,
                        role: EMessageRole.assistant,
                        sentAt: DateTime.now(),
                      ),
                    );
                  } else {
                    return ChatMessageTile(
                      message: provider.messages[index],
                      userImage: user?.photoURL ?? '',
                      userName: user?.displayName ?? '',
                    );
                  }
                },
              ));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
