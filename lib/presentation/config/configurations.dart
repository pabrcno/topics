import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/app/theme/theme_provider.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';

import '../../app/chat/chat_provider.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final ErrorCommander errorCommander = ErrorCommander();

  void _logout() {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.clearChatStates();

    AuthService().signOut();

    Navigator.of(context).pop();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(translate('sign_out')),
                    ),
                    const SizedBox(height: 16),
                    Text('Select Theme:'),
                    DropdownButton<String>(
                      onChanged: (newTheme) {
                        provider.fetchThemeData(
                            newTheme ?? 'assets/light_theme.json');
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'assets/light_theme.json',
                          child: Text('Light Theme'),
                        ),
                        DropdownMenuItem(
                          value: 'assets/dark_theme.json',
                          child: Text('Dark Theme'),
                        ),
                        DropdownMenuItem(
                          value: 'assets/system_theme.json',
                          child: Text('System Theme'),
                        ),
                        DropdownMenuItem(
                          value: 'assets/jungle_theme.json',
                          child: Text('Jungle Theme'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
