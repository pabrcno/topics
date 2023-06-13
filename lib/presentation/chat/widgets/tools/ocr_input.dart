import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
              toolbarColor: Colors.grey.shade800,
              backgroundColor: Colors.grey.shade800,
              cropFrameColor: Colors.lightBlue,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.lightBlue,
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
    return IconButton(
      onPressed: _openCamera,
      icon: const Icon(Icons.camera_alt),
    );
  }
}
