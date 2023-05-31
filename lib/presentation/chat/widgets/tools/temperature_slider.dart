import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../app/chat/chat_provider.dart';

class TemperatureSliderButton extends StatelessWidget {
  TemperatureSliderButton({Key? key}) : super(key: key);

  final ValueNotifier<double> _temperatureController =
      ValueNotifier<double>(0.5);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    _temperatureController.value =
        provider.currentChat?.temperature ?? _temperatureController.value;

    return TextButton(
      child: Text(
        translate('temperature'),
        style: TextStyle(color: Colors.blueGrey.shade100),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('consistency'),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        translate('diversity'),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _temperatureController,
                    builder: (context, value, child) {
                      return Slider(
                        value: value,
                        min: 0.1,
                        max: 1.5,
                        activeColor: Colors.blueGrey.shade100,
                        // for step size of 0.05
                        onChangeEnd: (double value) {
                          provider.setCurrentChatTemperature(value);
                        },
                        onChanged: (double value) {
                          _temperatureController.value = value;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _temperatureController,
                    builder: (context, value, child) {
                      return Text(
                        value.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
