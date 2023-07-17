import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityChatBody extends StatelessWidget {
  const AccessibilityChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(color: Colors.grey[200]), // Or your own background.
        ),
        Positioned(
          bottom: 0,
          child: InkWell(
            onTap: () {
              HapticFeedback.vibrate();
              // TODO: add more logic here
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.green, // Or your own color.
              child: const Center(
                child: Text('Tap me'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
