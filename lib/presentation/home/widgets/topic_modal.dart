import 'package:flutter/material.dart';

import '../../widgets/ocr_input.dart';

class TopicModal extends StatefulWidget {
  final Function(String title, String text) onSubmit;

  const TopicModal({super.key, required this.onSubmit});

  @override
  _TopicModalState createState() => _TopicModalState();
}

class _TopicModalState extends State<TopicModal> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _text = '';

  final TextEditingController _textController = TextEditingController();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_title, _text);
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
                  autofocus: true,
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
                      labelText: 'Make your first question or scan'),
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
