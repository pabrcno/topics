import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/chat/chat_provider.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() {
    String? apiKey = Provider.of<ChatProvider>(context, listen: false).apiKey;
    _controller.text = apiKey ?? '';
  }

  void _saveApiKey(String apiKey) {
    Provider.of<ChatProvider>(context, listen: false).saveApiKey(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'OpenAI API Key',
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
              onSubmitted: _saveApiKey,
            ),
            const SizedBox(height: 10.0),
            OutlinedButton(
              onPressed: () async => launchUrl(
                  Uri.parse(
                    'https://platform.openai.com',
                  ),
                  mode: LaunchMode.externalApplication),
              child: const Text('Get API Key'),
            ),
          ],
        ),
      ),
    );
  }
}
