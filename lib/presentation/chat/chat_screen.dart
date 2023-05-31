import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/chat_info.dart';
import 'package:topics/presentation/chat/widgets/chat_input.dart';
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
  final FocusNode _focusNode = FocusNode();
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

  double _contextWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
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
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatInfo(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatMessagesListView(
                chat: chat,
                isNew: isNew,
              ),
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
                  OCRInput(onOcrResult: (result) {
                    _textController.text = result;
                  }),
                  TemperatureSliderButton()
                ],
              ),
            ),
            ChatInput(
              textController: _textController,
              focusNode: _focusNode,
              onSend: () => _sendMessage(context),
            ),
          ],
        ),
      ),
    );
  }
}
