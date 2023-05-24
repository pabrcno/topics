import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
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
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Select your text',
              toolbarColor: Colors.green.shade700,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      final inputImage = InputImage.fromFilePath(croppedFile?.path ?? '');
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);

      setState(() {
        _text = recognizedText.text;
      });

      textDetector.close();
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
                const SizedBox(height: 16.0),
                if (_text.isEmpty)
                  TextButton(
                    onPressed: _openCamera,
                    child: const Text('Scan Text'),
                  )
                else
                  TextFormField(
                    initialValue: _text,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Text',
                    ),
                    onChanged: (value) => _text = value,
                  ),
                const SizedBox(height: 16.0),
                TextButton(
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
