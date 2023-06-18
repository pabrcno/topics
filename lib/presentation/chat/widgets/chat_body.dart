import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:topics/presentation/chat/widgets/chat_input.dart';
import 'package:topics/presentation/chat/widgets/chat_messages_list_view.dart';
import 'package:topics/presentation/chat/widgets/tools/image_generation_tools.dart';
import 'package:topics/presentation/chat/widgets/tools/ocr_input.dart';
import 'package:topics/presentation/chat/widgets/tools/prompt_builder.dart';
import 'package:topics/presentation/chat/widgets/tools/temperature_slider.dart';
import 'package:topics/presentation/chat/widgets/tools/tools_container.dart';
import '../../../app/chat/chat_provider.dart';

import '../../widgets/disabled.dart';

class ChatBody extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  final bool isNew;
  ChatBody({Key? key, this.isNew = false}) : super(key: key);
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    log(isKeyboardOpen.toString());
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Column(
        children: <Widget>[
          Flexible(
            child: Stack(
              children: [
                ChatMessagesListView(),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: !provider.isImageMode
                          ? Disabled(
                              disabled: provider.messageBuffer.isNotEmpty ||
                                  provider.isLoading,
                              child: ToolsContainer(
                                key: const ValueKey('PromptBuilder'),
                                widgetList: [
                                  OCRInput(onOcrResult: (result) {
                                    _textController.text = result;
                                  }),
                                  TemperatureSliderButton(),
                                ],
                              ),
                            )
                          : const SizedBox(
                              key: ValueKey('PromptBuilder'),
                              height: 0,
                              width: 0,
                            ),
                    )),
              ],
            ),
          ),
          ChatInput(
            textController: _textController,
            focusNode: _focusNode,
          ),
          !isKeyboardOpen
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: !provider.isImageMode
                      ? PromptBuilderTools(
                          key: const ValueKey('PromptBuilderTools'),
                        )
                      : ImageGenerationTools(
                          key: const ValueKey('ImageGenerationTools'),
                          textController: _textController,
                        ),
                )
              : Container(), // render an empty SizedBox when the keyboard is open
        ],
      ),
    );
  }
}
