import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';

class ChatInput extends StatefulWidget {
  final FocusNode _focusNode;
  final TextEditingController _textController;

  const ChatInput({
    Key? key,
    required FocusNode focusNode,
    required TextEditingController textController,
  })  : _focusNode = focusNode,
        _textController = textController,
        super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  double _contextWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image),
              color: provider.isImageMode
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () {
                provider.isImageMode = !provider.isImageMode;
              },
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: _contextWidth(context) -
                      120, // adjusted width for new IconButton
                  maxWidth: _contextWidth(context) -
                      120, // adjusted width for new IconButton
                  minHeight: 20.0,
                  maxHeight: 200,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    focusNode: widget._focusNode,
                    controller: widget._textController,
                    decoration: InputDecoration.collapsed(
                      hintText: translate('type_a_message'),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 30,
              icon: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.grey)
                  : provider.streamSubscription != null
                      ? Icon(
                          Icons.stop,
                          color: Colors.yellow.shade900,
                        )
                      : const Icon(Icons.send),
              onPressed: provider.streamSubscription != null
                  ? provider.stopStream
                  : () {
                      final messageText = widget._textController.text;
                      if (messageText.isEmpty) return;
                      if (!provider.isImageMode) {
                        provider.sendMessage(messageText);
                        widget._textController.clear();
                        return;
                      }
                      provider.sendImageGenerationRequest(
                        prompt: messageText,
                        weight: 0.5,
                        height: 512,
                        width: 512,
                        steps: 75,
                      );
                      widget._textController.clear();
                    },
            ),
          ],
        );
      },
    );
  }
}
