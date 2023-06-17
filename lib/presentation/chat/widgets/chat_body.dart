import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:topics/presentation/chat/widgets/chat_input.dart';
import 'package:topics/presentation/chat/widgets/chat_messages_list_view.dart';
import 'package:topics/presentation/chat/widgets/tools/image_generation_tools.dart';
import 'package:topics/presentation/chat/widgets/tools/ocr_input.dart';
import 'package:topics/presentation/chat/widgets/tools/temperature_slider.dart';
import 'package:topics/presentation/chat/widgets/tools/tools_container.dart';
import '../../../app/chat/chat_provider.dart';

import '../../widgets/disabled.dart';

class ChatBody extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  final bool isNew;
  ChatBody({super.key, this.isNew = false});
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Column(
        children: <Widget>[
          Expanded(
            child: ChatMessagesListView(),
          ),
          ChatInput(
            textController: _textController,
            focusNode: _focusNode,
          ),
          !provider.isImageMode
              ? Disabled(
                  disabled:
                      provider.messageBuffer.isNotEmpty || provider.isLoading,
                  child: ToolsContainer(
                    widgetList: [
                      OCRInput(onOcrResult: (result) {
                        _textController.text = result;
                      }),
                      TemperatureSliderButton(),
                      // SuggestedPromptSelector(
                      //   onSelect: (key, value) {
                      //     _textController.text = value;
                      //   },
                      // ),
                    ],
                  ),
                )
              : Disabled(
                  disabled:
                      provider.messageBuffer.isNotEmpty || provider.isLoading,
                  child: ImageGenerationTools(
                    textController: _textController,
                  )),
        ],
      ),
    );
  }
}
