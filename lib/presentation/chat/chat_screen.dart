import 'package:flutter/material.dart';
import 'package:topics/domain/models/question/question.dart';
import 'package:topics/mock_data.dart';
import 'package:topics/presentation/chat/widgets/chat_message_tile.dart';
import 'package:topics/presentation/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final Question question;
  const ChatScreen({super.key, required this.question});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages = mockMessages.where((message) {
      return message.questionId == widget.question.id;
    }).toList();
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.question.summary,
        chipsRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
                label: Text(
              'Created: ${widget.question.createdAt.day}-${widget.question.createdAt.month}-${widget.question.createdAt.year}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _textController.clear();
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
