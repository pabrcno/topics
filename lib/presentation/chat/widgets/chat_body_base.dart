import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:topics/presentation/chat/widgets/chat_input.dart';

import 'package:topics/presentation/chat/widgets/tools/image_equalizer.dart';
import 'package:topics/presentation/chat/widgets/tools/image_generation_tools.dart';
import 'package:topics/presentation/chat/widgets/tools/image_input.dart';
import 'package:topics/presentation/chat/widgets/tools/ocr_input.dart';
import 'package:topics/presentation/chat/widgets/tools/prompt_builder.dart';
import 'package:topics/presentation/chat/widgets/tools/temperature_slider.dart';
import 'package:topics/presentation/chat/widgets/tools/tools_container.dart';
import '../../../app/chat/chat_provider.dart';

import '../../widgets/disabled.dart';

class ChatBodyBase extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  final bool isNew;
  ChatBodyBase({Key? key, this.isNew = false}) : super(key: key);
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) => Column(
        children: <Widget>[
          Flexible(
            child: Stack(
              children: [
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
                            : Disabled(
                                key: const ValueKey('ImageTools'),
                                disabled: provider.messageBuffer.isNotEmpty ||
                                    provider.isLoading,
                                child: const ToolsContainer(
                                  widgetList: [
                                    ImageInput(),
                                    ImageEqualizerButton()
                                  ],
                                ),
                              ))),
                provider.initImagePath != null
                    ? Positioned(
                        bottom: 40,
                        right: 0,
                        child: InkWell(
                            child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 5),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.file(
                                  File(provider.initImagePath!),
                                  height: 75,
                                  fit: BoxFit.cover,
                                )),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        content: Image.file(
                                            File(provider.initImagePath!)),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(translate('delete')),
                                            onPressed: () {
                                              // Remove the image
                                              provider.initImagePath = null;
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            }))
                    : Container(),
              ],
            ),
          ),
          ChatInput(
            textController: _textController,
            focusNode: _focusNode,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: !provider.isImageMode
                ? const PromptBuilderTools(
                    key: ValueKey('PromptBuilderTools'),
                  )
                : ImageGenerationTools(
                    key: const ValueKey('ImageGenerationTools'),
                    textController: _textController,
                  ),
          )
        ],
      ),
    );
  }
}
