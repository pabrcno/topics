import 'dart:async';
import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/presentation/home/home.dart';
import 'package:topics/services/error_notifier.dart';

import 'app/core/chat_provider.dart';
import 'firebase_options.dart';

Future<String?> _loadOpenAiApiKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? apiKey = prefs.getString('apiKey');
  return apiKey;
}

void main() async {
  var errorNotifier = ErrorNotifier();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _loadOpenAiApiKey().then((value) {
    if (value != null) {
      OpenAI.apiKey = value;
      return;
    }
  });

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ErrorNotifier>.value(
            value: errorNotifier,
          ),

          ChangeNotifierProvider(create: (_) => ChatProvider()),
          // Add other providers if necessary
        ],
        child: MyApp(theme: theme),
      ),
    );
  }, (error, stackTrace) {
    errorNotifier.addError(error);
  });
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
