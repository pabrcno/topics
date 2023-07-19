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
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return chatProvider.messages.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                var screenWidth = MediaQuery.of(context).size.width;
                if (details.localPosition.dx < screenWidth * 0.25) {
                  if (currentIndex > 0) {
                    setState(() {
                      currentIndex--;
                    });
                  }
                } else if (details.localPosition.dx > screenWidth * 0.75) {
                  if (currentIndex < chatProvider.messages.length - 1) {
                    setState(() {
                      currentIndex++;
                    });
                  }
                }
              },
              child: AccessibilityChatTile(
                  message: chatProvider.messages[currentIndex]),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.75,
            );
    });
  }
}
