import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/chat/chat_provider.dart';

class TopicModal extends StatefulWidget {
  const TopicModal({super.key});

  @override
  _TopicModalState createState() => _TopicModalState();
}

class _TopicModalState extends State<TopicModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Dialog(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Topic Title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Your can store related chats on Topics. Choose a good one!';
                          }
                          return null;
                        },
                        controller: _textController,
                      ),
                      const SizedBox(height: 28.0),
                      // create button
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            chatProvider.createTopic(_textController.text);
                          }
                        },
                        child: const Text('Go to Chat >'),
                      ),
                    ]),
                  ),
                )));
      },
    );
  }
}
