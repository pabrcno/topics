import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topics/presentation/chat/chat_screen.dart';

import '../../../app/chat/chat_provider.dart';
import '../../../domain/models/chat/chat.dart';
import '../../widgets/app_chip.dart';

class ChatsList extends StatelessWidget {
  final List<Chat> chats;

  const ChatsList({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats.length,
      padding: const EdgeInsets.only(top: 20),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 20,
          thickness: 1,
          color: Theme.of(context).hintColor,
        );
        // Customize your separator
      },
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          title: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(chat.summary.split('\n').take(5).join('\n'))),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppChip(
                label:
                    'Created: ${chat.createdAt.day}-${chat.createdAt.month}-${chat.createdAt.year}',
              ),
              const SizedBox(
                height: 4.0,
              ),
              AppChip(
                label:
                    'Last updated: ${chat.lastModified.day}-${chat.lastModified.month}-${chat.lastModified.year}',
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            final chatProvider =
                Provider.of<ChatProvider>(context, listen: false);
            chatProvider.setCurrentChatId(chat.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
