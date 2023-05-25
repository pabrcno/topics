import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/mock_data.dart';
import 'package:topics/presentation/chat/widgets/chat_message_tile.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';
import 'package:topics/presentation/widgets/ocr_input.dart';

import '../../app/chat/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late final ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  void _sendMessage() {
    final messageText = _textController.text;
    if (messageText.isNotEmpty) {
      _chatProvider.sendMessage(messageText);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = mockMessages;
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.chat.summary,
        chipsRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
                label: Text(
              'Created: ${widget.chat.createdAt.day}-${widget.chat.createdAt.month}-${widget.chat.createdAt.year}',
              style: Theme.of(context).textTheme.titleSmall,
            )),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatMessageTile(message: messages[index]);
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
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _sendMessage();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
