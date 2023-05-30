import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_messages_list_view.dart';
import 'package:topics/presentation/chat/widgets/tools/temperature_slider.dart';
import 'package:topics/presentation/chat/widgets/tools/tools_container.dart';
import '../../app/chat/chat_provider.dart';
import '../../domain/models/chat/chat.dart';
import '../widgets/disabled.dart';
import 'widgets/tools/ocr_input.dart';
import 'widgets/tools/suggested_prompt_selector.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Chat chat;
  final bool isNew;
  ChatScreen({super.key, required this.chat, this.isNew = false});

  void _sendMessage(BuildContext context) async {
    final messageText = _textController.text;
    if (messageText.isNotEmpty) {
      _textController.clear();
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(messageText);
      _scrollToBottom(_scrollController);
    }
  }

  void _scrollToBottom(ScrollController scrollController) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ChatProvider>(context, listen: false).fetchMessages();
    });

    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            chat.summary,
            maxLines: 2,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatMessagesListView(
                scrollController: _scrollController,
                chat: chat,
                isNew: isNew,
              ),
            ),
            Divider(
              height: 1,
              color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                  Colors.white,
            ),
            Disabled(
              disabled: provider.messageBuffer.isNotEmpty || provider.isLoading,
              child: ToolsContainer(
                widgetList: [
                  SuggestedPromptSelector(
                    onSelect: (key, value) {
                      _textController.text = value;
                    },
                  ),
                  SizedBox(
                      width: 130,
                      child: OCRInput(onOcrResult: (result) {
                        _textController.text = result;
                      })),
                  TemperatureSliderButton()
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: translate('type_a_message'),
                    ),
                    style: const TextStyle(fontSize: 18),
                  )),
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
