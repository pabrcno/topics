import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController _textController;
  final FocusNode _focusNode;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required TextEditingController textController,
    required FocusNode focusNode,
    required this.onSend,
  })  : _textController = textController,
        _focusNode = focusNode;

  double _contextWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: _contextWidth(context) - 75,
                  maxWidth: _contextWidth(context) - 75,
                  minHeight: 50.0,
                  maxHeight: 300,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    focusNode: _focusNode,
                    controller: _textController,
                    decoration: InputDecoration.collapsed(
                      hintText: translate('type_a_message'),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 30,
              icon: provider.streamSubscription != null
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.send),
              onPressed: provider.streamSubscription != null
                  ? provider.stopStream
                  : onSend,
            ),
          ],
        );
      },
    );
  }
}
