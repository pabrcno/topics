import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/chat/chat_provider.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  final ErrorCommander errorCommander = ErrorCommander();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() {
    String? apiKey = storageServiceProvider.getApiKey();
    _controller.text = apiKey ?? '';
  }

  Future<void> _saveApiKey() async {
    await errorCommander.run(() async {
      if (_controller.text.length != OPENAI_API_KEY_LENGTH) {
        throw FormatException(translate('invalid_api_key'));
      }
      storageServiceProvider.saveApiKey(_controller.text);
    });
  }

  void _logout() {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.clearChatStates();
    storageServiceProvider.clearApiKey();
    AuthService().signOut();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('configurations')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: translate('openai_api_key'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  onSubmitted: (_) {
                    _saveApiKey();
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: () async => launchUrl(
                          Uri.parse(
                            'https://platform.openai.com/account/api-keys',
                          ),
                          mode: LaunchMode.externalApplication),
                      child: Text(translate('get_api_key')),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _saveApiKey();
                        //show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green.shade200,
                            content:
                                Text(translate('api_key_set_successfully'))));
                      },
                      child: Text(translate('set_api_key')),
                    ),
                  ],
                )
              ],
            ),
            OutlinedButton(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(translate('sign_out')))
          ],
        ),
      ),
    );
  }
}
