import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/presentation/chat/widgets/chat_message_tile.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';
import 'package:topics/presentation/widgets/ocr_input.dart';
import '../../app/chat/chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;
  final TextEditingController _textController = TextEditingController();

  ChatScreen({Key? key, required this.chat}) : super(key: key);

  void _sendMessage(BuildContext context) async {
    final messageText = _textController.text;
    if (messageText.isNotEmpty) {
      _textController.clear();
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(messageText);
    }
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
              Chip(
                  label: Text(
                'Created: ${chat.createdAt.day}-${chat.createdAt.month}-${chat.createdAt.year}',
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageTile(message: provider.messages[index]);
                },
              ),
            ),
            const SizedBox(height: 10),
            OCRInput(onOcrResult: (result) {
              _textController.text = result;
            }),
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
                    icon: provider.isLoading
                        ? const CircularProgressIndicator()
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
