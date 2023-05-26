import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../widgets/ocr_input.dart';

class NewChatModal extends StatefulWidget {
  final Function(String text, String topicId) onSubmit;
  final String topicId;

  const NewChatModal({Key? key, required this.onSubmit, required this.topicId})
      : super(key: key);

  @override
  _NewChatModalState createState() => _NewChatModalState();
}

class _NewChatModalState extends State<NewChatModal> {
  final _formKey = GlobalKey<FormState>();
  String _text = '';

  final TextEditingController _textController = TextEditingController();

  void _submitForm() {
    final openAIProvider = Provider.of<ChatProvider>(context, listen: false);
    if (openAIProvider.apiKey == null || openAIProvider.apiKey!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key is not set. Please configure it first.'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(
        _text,
        widget.topicId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                controller: _textController,
                maxLines: null,
                decoration: const InputDecoration(
                    labelText: 'Write your first message or scan'),
                onChanged: (value) => _text = value,
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
