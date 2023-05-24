import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_title, _text);
    }
  }

  Future<void> _openCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);

      setState(() {
        _text = recognizedText.text;
      });

      textDetector
          .close(); // Make sure to dispose the detector when not needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              TextButton(
                onPressed: _openCamera,
                child: const Text('Open Camera'),
              ),
              const SizedBox(height: 16.0),
              Text('OCR Text: $_text'),
              const SizedBox(height: 16.0),
              TextButton(
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
