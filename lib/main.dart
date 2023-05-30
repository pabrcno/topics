import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:topics/repo/chat/firestore_chat_repository.dart';
import 'package:topics/repo/user/firestore_user_repo.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';
import 'package:topics/services/storage_service.dart';

import 'api/openAi/chat_api.dart';
import 'app/chat/chat_provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await storageServiceProvider.initializePrefs();
  final openAIApiKey = storageServiceProvider.getApiKey();
  if (openAIApiKey != null) {
    OpenAI.apiKey = openAIApiKey;
  }

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ChatProvider>(
        create: (context) => ChatProvider(
          chatRepository: FirestoreChatRepository(),
          userRepository: FirestoreUserRepository(),
          authServiceProvider: AuthService(),
          chatApi: OpenAIChatApi(),
        ), // Pass context to ErrorCommander
      ),
    ], child: MyApp(theme: theme)),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: AuthService().handleAuthState(),
      theme: theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        ErrorCommander.showSnackbar = (String message) async {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          return Future.value();
        };
        return child!;
      },
    );
  }
}
