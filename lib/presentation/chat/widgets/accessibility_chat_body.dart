import 'package:flutter/material.dart';
import 'package:topics/presentation/chat/widgets/accessibility_input.dart';

import 'accessibility_chat_list.dart';

class AccessibilityChatBody extends StatelessWidget {
  const AccessibilityChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        AccessibilityMessagesContainer(),
        AccessibilityInput()
      ],
    );
  }
}
