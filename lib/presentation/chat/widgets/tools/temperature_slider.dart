import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../app/chat/chat_provider.dart';

class TemperatureSliderButton extends StatelessWidget {
  TemperatureSliderButton({Key? key}) : super(key: key);

  final ValueNotifier<double> _temperatureController =
      ValueNotifier<double>(0.7);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    _temperatureController.value =
        provider.currentChat?.temperature ?? _temperatureController.value;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        Text(
                          translate('diversity'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                          activeColor: Theme.of(context).colorScheme.tertiary,
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
        child: Text(
          translate('temperature'),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary, fontSize: 12),
        ));
  }
}
