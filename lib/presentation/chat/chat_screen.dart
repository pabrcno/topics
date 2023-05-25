import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/presentation/chat/widgets/chat_message_tile.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';
import 'package:topics/presentation/widgets/ocr_input.dart';
import '../../app/chat/chat_provider.dart';
import '../../domain/core/enums.dart';
import '../../domain/models/message/message.dart';
import '../widgets/app_chip.dart';
import '../widgets/disabled.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatScreen({Key? key, required this.chat}) : super(key: key);

  void _sendMessage(BuildContext context) async {
    final messageText = _textController.text;
    if (messageText.isNotEmpty) {
      _textController.clear();
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(messageText);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: CustomAppBar(
          title: chat.summary,
          chipsRow: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppChip(
                label:
                    'Created: ${chat.createdAt.day}-${chat.createdAt.month}-${chat.createdAt.year}',
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: provider.messages.length +
                    (provider.messageBuffer.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.messages.length) {
                    return ChatMessageTile(
                      message: Message(
                        content: provider.messageBuffer,
                        id: 'new',
                        chatId: chat.id,
                        isUser: false,
                        role: EMessageRole.assistant,
                        sentAt: DateTime.now(),
                      ),
                    );
                  } else {
                    return ChatMessageTile(message: provider.messages[index]);
                  }
                },
              ),
            ),
            Disabled(
              disabled: provider.messageBuffer.isNotEmpty || provider.isLoading,
              child: OCRInput(onOcrResult: (result) {
                _textController.text = result;
              }),
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                  Colors.white,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    icon:
                        provider.isLoading || provider.messageBuffer.isNotEmpty
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                              )
                            : const Icon(Icons.send),
                    onPressed:
                        provider.isLoading ? null : () => _sendMessage(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
