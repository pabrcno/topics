import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/speech_input.dart';

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
        return Container(
            decoration: BoxDecoration(
              color: provider.isImageMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, -3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.image),
                  color: provider.isImageMode
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.grey,
                  onPressed: () {
                    provider.isImageMode = !provider.isImageMode;
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _contextWidth(context) -
                          150, // adjusted width for new IconButton
                      maxWidth: _contextWidth(context) -
                          150, // adjusted width for new IconButton
                      minHeight: 20.0,
                      maxHeight: 240,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: TextField(
                        cursorColor: provider.isImageMode
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 2,
                        focusNode: widget._focusNode,
                        controller: widget._textController,
                        decoration: InputDecoration.collapsed(
                          hintText: translate('type_a_message'),
                          hintStyle: TextStyle(
                            color: provider.isImageMode
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.5)
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: provider.isImageMode
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                ),
                SpeechInput(
                  controller: widget._textController,
                ),
                const SizedBox(width: 5),
                provider.isLoading && provider.messageBuffer.isEmpty
                    ? SizedBox(
                        height: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.grey.shade600,
                          strokeWidth: 1,
                        ),
                      )
                    : Material(
                        color: provider.streamSubscription != null
                            ? Colors.yellow.shade900
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: provider.streamSubscription != null
                              ? provider.stopStream
                              : () {
                                  final messageText =
                                      widget._textController.text;
                                  if (messageText.isEmpty) return;
                                  if (!provider.isImageMode) {
                                    provider.sendMessage(messageText);
                                    widget._textController.clear();
                                    return;
                                  }
                                  provider.sendImageGenerationRequest(
                                    prompt: messageText,
                                    weight: 0.5,
                                    height: 1024,
                                    width: 1024,
                                  );
                                  widget._textController.clear();
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: provider.streamSubscription != null
                                ? Icon(Icons.stop,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)
                                : Icon(Icons.send_rounded,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                          ),
                        ),
                      ),
              ],
            ));
      },
    );
  }
}
