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
  final FocusNode _focusNode = FocusNode();

  final bool isNew;
  ChatScreen({super.key, this.isNew = false});
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              String? newSummary = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  String tempSummary = '';
                  return AlertDialog(
                    title: const Text('Change Summary'),
                    content: TextField(
                      onChanged: (value) {
                        tempSummary = value;
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter new summary"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, tempSummary);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );

              if (newSummary != null) {
                Chat? chatWithNewSummary =
                    provider.currentChat?.copyWith(summary: newSummary);
                if (chatWithNewSummary != null) {
                  await provider.modifyChatSummary(chatWithNewSummary);
                }
              }
            },
            child: Text(
              provider.currentChat!.summary,
              maxLines: 2,
            ),
          ),
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatInfo(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatMessagesListView(),
            ),
            Disabled(
              disabled: provider.messageBuffer.isNotEmpty || provider.isLoading,
              child: ToolsContainer(
                widgetList: [
                  OCRInput(onOcrResult: (result) {
                    _textController.text = result;
                  }),
                  TemperatureSliderButton(),
                  SuggestedPromptSelector(
                    onSelect: (key, value) {
                      _textController.text = value;
                    },
                  ),
                ],
              ),
            ),
            ChatInput(
              textController: _textController,
              focusNode: _focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
