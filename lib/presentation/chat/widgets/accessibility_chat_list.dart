import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/widgets/accessibility_chat_tile.dart';

import '../../../app/chat/chat_provider.dart';

class AccessibilityMessagesContainer extends StatefulWidget {
  const AccessibilityMessagesContainer({Key? key}) : super(key: key);

  @override
  _AccessibilityMessagesContainerState createState() =>
      _AccessibilityMessagesContainerState();
}

class _AccessibilityMessagesContainerState
    extends State<AccessibilityMessagesContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return SizedBox(
          width: screenWidth,
          height: screenHeight * 0.70,
          child: Stack(
            children: [
              // Middle section (Chat list)
              Positioned(
                top: 10,
                bottom: 0,
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight, // Providing height to the SizedBox
                  child: chatProvider.messages.isNotEmpty
                      ? AccessibilityChatTile(
                          message: chatProvider
                              .messages[chatProvider.currentMessageIndex],
                        )
                      : Container(),
                ),
              ),
              // Left navigator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: screenWidth * 0.15,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (chatProvider.currentMessageIndex > 0) {
                        chatProvider.currentMessageIndex--;
                      }
                    },
                  ),
                ),
              ),
              // Right navigator
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: screenWidth * 0.15,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (chatProvider.currentMessageIndex <
                          chatProvider.messages.length - 1) {
                        chatProvider.currentMessageIndex++;
                      }
                    },
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
