import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:topics/presentation/chat/widgets/message_share_button.dart';
import 'package:topics/presentation/chat/widgets/tts_button.dart';
import 'package:topics/services/exception_handling_service.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../domain/core/enums.dart';
import '../../../domain/models/message/message.dart';

class ChatMessageTile extends StatelessWidget {
  final Message message;
  final String userImage;
  final String userName;

  const ChatMessageTile({
    Key? key,
    required this.message,
    required this.userImage,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: message.role == EMessageRole.user
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                        radius: 12,
                      ),
                      MessageShareButton(message: message.content),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/topics_light_removebg.png',
                          height: 25),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: EMessageRole.imageAssistant != message.role
                                ? TTSButton(text: message.content)
                                : const SizedBox(),
                          ),
                          MessageShareButton(message: message.content),
                        ],
                      )
                    ],
                  ),
          ),
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
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MarkdownBody(
                    fitContent: false,
                    selectable: true,
                    data: message.content,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: const TextStyle(
                        fontSize: 16,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      codeblockPadding: const EdgeInsets.all(8.0),
                      code: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ),
          Divider(
            color: Colors.grey[100],
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}
