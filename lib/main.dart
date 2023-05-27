import 'dart:async';
import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/api/openAi/chat_api.dart';
import 'package:topics/repo/chat/firestore_chat_repository.dart';
import 'package:topics/services/auth_service.dart';
import 'package:topics/services/exception_notifier.dart';
import 'package:topics/utils/constants.dart';

import 'app/chat/chat_provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<String?> _loadOpenAiApiKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? apiKey = prefs.getString('apiKey');
  return apiKey;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _loadOpenAiApiKey().then((value) {
    if (value != null && value.length == OPENAI_API_KEY_LENGTH) {
      OpenAI.apiKey = value;
      return;
    }
  });

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  var exceptionNotifier = ExceptionNotifier();
  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ExceptionNotifier>.value(
              value: exceptionNotifier),
          ChangeNotifierProvider<ChatProvider>(
            create: (context) => ChatProvider(
                chatRepository: FirestoreChatRepository(),
                exceptionNotifier: exceptionNotifier,
                chatApi: OpenAIChatApi()),
          ),
        ],
        child: MyApp(theme: theme),
      ),
    );
  }, (exception, stackTrace) {
    exceptionNotifier.addException(exception);
  });
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: authServiceProvider.handleAuthState(),
      theme: theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              var errorNotifier = Provider.of<ExceptionNotifier>(context);
              if (errorNotifier.lastException != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(errorNotifier.lastException.toString())),
                  );
                });
                // clear the error
              }
              return child!;
            },
          ),
        );
      },
    );
  }
}
