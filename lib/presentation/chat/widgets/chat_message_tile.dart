import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: () {
          switch (message.role) {
            case EMessageRole.user:
              return Theme.of(context).colorScheme.surfaceVariant;

            case EMessageRole.assistant:
              return Theme.of(context).colorScheme.surface;

            case EMessageRole.system:
              return Colors.grey;

            case EMessageRole.imageAssistant:
              return Colors.transparent;
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
              : Padding(
                  padding: EdgeInsets.all(18),
                  child: MarkdownBody(
                    fitContent: false,
                    selectable: true,
                    data: message.content,
                  )),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
