import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:topics/presentation/chat/widgets/message_share_button.dart';
import 'package:topics/services/exception_handling_service.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../domain/core/enums.dart';
import '../../../domain/models/message/message.dart';

// Don't forget to import your MessageShareButton

class ChatMessageTile extends StatelessWidget {
  final Message message;

  const ChatMessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: message.role == EMessageRole.imageAssistant ? 0 : 5,
          vertical: message.role == EMessageRole.imageAssistant ? 0 : 10),
      decoration: BoxDecoration(
        color: () {
          switch (message.role) {
            case EMessageRole.user:
              return Colors.grey.shade900;

            case EMessageRole.assistant:
              return Colors.black;

            case EMessageRole.system:
              return Colors.grey;

            case EMessageRole.imageAssistant:
              return Colors.black;
            default:
              return Colors
                  .grey; // default color in case none of the roles match
          }
        }(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.role == EMessageRole.imageAssistant
              ? InkWell(
                  onDoubleTap: () async {
                    ErrorCommander().run(() async {
                      var file = await DefaultCacheManager()
                          .getSingleFile(message.content);
                      await ImageGallerySaver.saveImage(
                          File(file.path).readAsBytesSync());
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image saved to gallery'),
                        ),
                      );
                    });
                  },
                  child: FadeInImage.memoryNetwork(
                    placeholder:
                        kTransparentImage, // this is a transparent placeholder from the transparent_image package
                    image: message.content,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    fadeInDuration: const Duration(seconds: 1),
                    // adjust duration according to your needs
                  ))
              : SelectableText(
                  message.content,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${message.sentAt.hour}:${message.sentAt.minute}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                MessageShareButton(message: message.content),
              ],
            ),
          )
        ],
      ),
    );
  }
}
