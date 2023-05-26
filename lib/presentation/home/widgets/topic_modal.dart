import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';
import '../../widgets/ocr_input.dart';

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

  void _submitForm() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (!chatProvider.isApiKeySet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key is not set. Please configure it first.'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pop();
        await chatProvider.createTopic(_title, _text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating topic: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
