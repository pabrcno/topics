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
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return chatProvider.messages.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                var screenWidth = MediaQuery.of(context).size.width;
                if (details.localPosition.dx < screenWidth * 0.25) {
                  if (chatProvider.currentMessageIndex > 0) {
                    chatProvider.currentMessageIndex--;
                  }
                } else if (details.localPosition.dx > screenWidth * 0.75) {
                  if (chatProvider.currentMessageIndex <
                      chatProvider.messages.length - 1) {
                    chatProvider.currentMessageIndex++;
                  }
                }
              },
              child: AccessibilityChatTile(
                  message:
                      chatProvider.messages[chatProvider.currentMessageIndex]),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.75,
            );
    });
  }
}
