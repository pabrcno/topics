import 'package:flutter/material.dart';

import '../../utils/constants.dart';

typedef OnSelect = void Function(String key, String value);

class SuggestedPromptSelector extends StatefulWidget {
  final Map<String, String> prompts;
  final OnSelect onSelect;
  const SuggestedPromptSelector({
    super.key,
    required this.onSelect,
    this.prompts = defaultSuggestedPrompts,
  });

  @override
  _SuggestedPromptSelectorState createState() =>
      _SuggestedPromptSelectorState();
}

class _SuggestedPromptSelectorState extends State<SuggestedPromptSelector> {
  String? selectedPrompt;

  @override
  void initState() {
    super.initState();
    selectedPrompt = null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedPrompt,
      hint: const Text('Suggested prompts'),
      onChanged: (String? newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          setState(() {
            selectedPrompt = newValue;
            widget.onSelect(selectedPrompt!, widget.prompts[selectedPrompt]!);
          });
        }
      },
      items: widget.prompts.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
