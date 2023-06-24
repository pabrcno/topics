import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/theme/theme_provider.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';

import '../../app/chat/chat_provider.dart';
import '../../domain/models/message/message.dart';
import '../../services/notification_service.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final ErrorCommander errorCommander = ErrorCommander();
  final Map<String, String> themePaths = {
    'assets/light_theme.json': 'Light Theme',
    'assets/dark_theme.json': 'Dark Theme',
    'assets/system_theme.json': 'System Theme',
    'assets/jungle_theme.json': 'Jungle Theme',
    'assets/strawberry_theme.json': 'Strawberry Theme',
  };

  void _logout() {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.clearChatStates();

    AuthService().signOut();

    Navigator.of(context).pop();
  }

  Future<void> _showThemePicker(
      BuildContext context, ThemeProvider provider) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: provider.isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: themePaths.length,
                  itemBuilder: (context, index) {
                    final entry = themePaths.entries.elementAt(index);
                    return ListTile(
                      title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(entry.value)),
                      leading: Icon(provider.themePath == entry.key
                          ? Icons.check
                          : Icons.blur_circular_rounded),
                      onTap: () {
                        provider.fetchThemeData(entry.key);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, provider, child) => Scaffold(
              appBar: AppBar(
                title: Text(translate('configurations')),
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      child: Text(themePaths[provider.themePath]!),
                      onPressed: () => _showThemePicker(context, provider),
                    ),
                    OutlinedButton(
                        onPressed: () {
                          final provider =
                              Provider.of<ChatProvider>(context, listen: false);

                          final notificationService = NotificationService(
                              onMessageReply: provider.sendMessage,
                              onImageGeneration: (prompt) async {
                                await provider.sendImageGenerationRequest(
                                    width: 512,
                                    height: 512,
                                    weight: 0.5,
                                    prompt: prompt);
                              });
                          final message = provider.messages.isNotEmpty
                              ? provider.messages.last
                              : Message(
                                  content: translate('ask_me_anything'),
                                  role: EMessageRole.assistant,
                                  chatId: provider.currentChat?.id ?? '',
                                  id: 'INITIAL_NOTIFICATION_MESSAGE',
                                  isUser: false,
                                  sentAt: DateTime.now());
                          notificationService.createChatNotification(
                              message.content, message.role);
                        },
                        child: Text(
                          translate("open_notification"),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        )),
                    OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(translate('sign_out')),
                    ),
                    const SizedBox(height: 16),

                    // More configuration options can be added here...
                  ],
                ),
              ),
            ));
  }
}
