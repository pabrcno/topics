// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class OCRInput extends StatefulWidget {
  final Function(String result) onOcrResult;

  const OCRInput({required this.onOcrResult, Key? key}) : super(key: key);

  @override
  _OCRInputState createState() => _OCRInputState();
}

class _OCRInputState extends State<OCRInput> {
  Future<void> _openCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Select your text',
              toolbarColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              cropFrameColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Theme.of(context).colorScheme.primary,
              activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
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
      final textDetector = TextRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);

      textDetector.close();

      // Call the callback function with the OCR result.
      widget.onOcrResult(recognizedText.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(5)),
        onPressed: _openCamera,
        child: Text(
          'OCR',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
