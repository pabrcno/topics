import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

const Map<String, String> defaultSuggestedPrompts = {
  "note_taking_assistant_title": "Note-taking assistant",
  "chat_gpt_prompt_title": "ChatGPT Prompt",
  "proofreader_title": "Proofreader",
  "diagram_title": "Diagram",
  "midjourney_prompt_title": "Midjourney Prompt",
  "math_teacher_title": "Math Teacher",
};

typedef OnSelect = void Function(String key, String value);

class SuggestedPromptSelector extends StatefulWidget {
  final Map<String, String> prompts;
  final OnSelect onSelect;

  const SuggestedPromptSelector({
    Key? key,
    required this.onSelect,
    this.prompts = defaultSuggestedPrompts,
  }) : super(key: key);

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
      hint: Text(translate("suggested_prompts")),
      onChanged: (String? newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          setState(() {
            selectedPrompt = newValue;
            widget.onSelect(
              selectedPrompt!,
              translate(widget.prompts[selectedPrompt]!),
            );
          });
        }
      },
      items: widget.prompts.keys.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(translate(value)),
          );
        },
      ).toList(),
    );
  }
}
