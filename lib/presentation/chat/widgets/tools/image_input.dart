import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/chat/chat_provider.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({Key? key}) : super(key: key);

  Future<void> _pickImage(ImageSource source, ChatProvider chatProvider) async {
    final ImagePicker _picker = ImagePicker();
    // Pick image
    final XFile? image = await _picker.pickImage(
        maxHeight: 1024, maxWidth: 1024, source: source);
    if (image != null) {
      // Cropping image
      final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.png,
      );
      if (cropped != null) {
        chatProvider.initImagePath = cropped.path;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (ctx, chatProvider, _) {
      return chatProvider.initImagePath == null
          ? ElevatedButton.icon(
              label: Text(translate('addImage')),
              icon: const Icon(Icons.photo_camera_back),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                TextButton.icon(
                                  icon: const Icon(Icons.photo_camera_back),
                                  label: Text(translate('takePicture')),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _pickImage(
                                        ImageSource.camera, chatProvider);
                                  },
                                ),
                                const SizedBox(height: 40),
                                TextButton.icon(
                                  icon: const Icon(Icons.photo_library),
                                  label: Text(translate('pickFromGallery')),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _pickImage(
                                        ImageSource.gallery, chatProvider);
                                  },
                                )
                              ],
                            ),
                          ),
                        ));
              },
            )
          : InkWell(
              child: Container(
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.file(
                    File(chatProvider.initImagePath!),
                    height: 75,
                    fit: BoxFit.cover,
                  )),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content:
                              Image.file(File(chatProvider.initImagePath!)),
                          actions: <Widget>[
                            TextButton(
                              child: Text(translate('delete')),
                              onPressed: () {
                                // Remove the image
                                chatProvider.initImagePath = null;
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ));
              });
    });
  }
}
