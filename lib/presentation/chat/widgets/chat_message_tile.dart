import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/chat/chat_provider.dart';
import 'package:topics/presentation/chat/widgets/message_share_button.dart';
import 'package:topics/presentation/chat/widgets/tts_button.dart';
import 'package:topics/services/exception_handling_service.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/theme_provider.dart';
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
  void _handleLinkTap(String? href) {
    if (href != null && href.isNotEmpty) {
      if (href.startsWith('http') || href.startsWith('https')) {
        Uri link = Uri.parse(href);
        launchUrl(link);
      }
    }
  }

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
                      Image.asset(Provider.of<ThemeProvider>(context).logoUrl,
                          height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: EMessageRole.assistant == message.role
                                ? TTSButton(text: message.content)
                                : const SizedBox(),
                          ),
                          MessageShareButton(message: message.content),
                        ],
                      )
                    ],
                  ),
          ),
          const SizedBox(height: 5),
          message.role == EMessageRole.imageAssistant
              ? InkWell(
                  onLongPress: () async {
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
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.1,
                    maxScale: 4,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: message.content,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          fadeInDuration: const Duration(seconds: 1),
                        )),
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MarkdownBody(
                    fitContent: false,
                    selectable: true,
                    data: message.content,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      blockSpacing: 25,
                      codeblockDecoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      p: TextStyle(fontSize: 18),
                      codeblockPadding: const EdgeInsets.all(8.0),
                      code: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    onTapLink: (text, href, title) {
                      _handleLinkTap(href);
                    },
                  ),
                ),
          Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  message.role == EMessageRole.assistant && message.id != 'new'
                      ? IconButton(
                          onPressed: () {
                            Provider.of<ChatProvider>(context, listen: false)
                                .generateMessageSearch(
                                    translate("search_message_title"), message);
                          },
                          icon: const Icon(Icons.search))
                      : const SizedBox()
                ],
              )),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
