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
  bool _isImageMode = false;

  double _contextWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  void _sendMessage(BuildContext context) async {
    final messageText = widget._textController.text;
    if (messageText.isNotEmpty) {
      widget._textController.clear();

      if (_isImageMode) {
        await Provider.of<ChatProvider>(context, listen: false)
            .sendImageGenerationRequest(
          prompt: messageText,
          weight: 0.5,
          height: 512,
          width: 512,
          steps: 75,
        );
        setState(() {
          _isImageMode = false;
        });
        return;
      }
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(messageText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.image),
              color: _isImageMode
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () {
                setState(() {
                  _isImageMode = !_isImageMode;
                });
              },
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 30, top: 5),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: _contextWidth(context) -
                      120, // adjusted width for new IconButton
                  maxWidth: _contextWidth(context) -
                      120, // adjusted width for new IconButton
                  minHeight: 50.0,
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
                  : () => _sendMessage(context),
            ),
          ],
        );
      },
    );
  }
}
