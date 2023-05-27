import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/topic/topic.dart';
import '../../widgets/ocr_input.dart';
import '../../widgets/suggested_prompt_selector.dart';

class NewChatModal extends StatelessWidget {
  final Topic topic;

  NewChatModal({Key? key, required this.topic}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _submitForm() {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      Navigator.of(context).pop();
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final text = _textController.text;
        chatProvider.createChat(text, topic);
      }
    }

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SuggestedPromptSelector(
                  onSelect: (key, value) {
                    _textController.text = value;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Write your first message or scan'),
                ),
              ),
              const SizedBox(height: 10.0),
              OCRInput(onOcrResult: (result) {
                _textController.text = result;
              }),
              const SizedBox(height: 28.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
