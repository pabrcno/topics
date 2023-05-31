import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('about')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate('about_the_app'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              translate('app_description'),
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              translate('key_features'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: Text(translate('text_scanning')),
              subtitle: Text(translate('text_scanning_description')),
            ),
            ListTile(
              leading: const Icon(Icons.auto_stories),
              title: Text(translate('prompt_suggestion')),
              subtitle: Text(translate('prompt_suggestion_description')),
            ),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: Text(translate('temperature_control')),
              subtitle: Text(translate('temperature_control_description')),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: Text(translate('group_chats')),
              subtitle: Text(translate('group_chats_description')),
            ),
            const SizedBox(height: 42.0),
            Text(
              translate('commitment'),
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
