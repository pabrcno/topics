import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../widgets/ocr_input.dart';
import '../../widgets/suggested_prompt_selector.dart';

class TopicModal extends StatefulWidget {
  const TopicModal({super.key});

  @override
  _TopicModalState createState() => _TopicModalState();
}

class _TopicModalState extends State<TopicModal> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _text = '';

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Topic Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a topic title';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    const SizedBox(height: 28.0),
                    SuggestedPromptSelector(
                      onSelect: (key, value) {
                        _textController.text = value;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Write your first message or scan',
                      ),
                      onChanged: (value) => _text = value,
                    ),
                    const SizedBox(height: 10.0),
                    OCRInput(onOcrResult: (result) {
                      _textController.text = result;
                    }),
                    const SizedBox(height: 28.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final messageText = _textController.text;
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();
                          await chatProvider.createTopic(_title, messageText);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
