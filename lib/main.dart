import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
Future<LocalizationDelegate> setupLocalizationDelegate() async {
  var localizationDelegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'es_ES']);

  return localizationDelegate;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var localizationDelegate = await setupLocalizationDelegate();

  await storageServiceProvider.initializePrefs();
  final openAIApiKey = storageServiceProvider.getApiKey();
  if (openAIApiKey != null) {
    OpenAI.apiKey = openAIApiKey;
  }

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatProvider>(
            create: (context) => ChatProvider(
              chatRepository: FirestoreChatRepository(),
              userRepository: FirestoreUserRepository(),
              authServiceProvider: AuthService(),
              chatApi: OpenAIChatApi(),
            ), // Pass context to ErrorCommander
          ),
        ],
        child: MyApp(
          theme: theme,
          localizationDelegate: localizationDelegate,
        )),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  final LocalizationDelegate localizationDelegate;
  const MyApp({
    Key? key,
    required this.theme,
    required this.localizationDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      localizationDelegate,
      MaterialApp(
        navigatorKey: navigatorKey,
        home: AuthService().handleAuthState(),
        theme: theme,
        localizationsDelegates: [
          localizationDelegate,
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          ErrorCommander.showSnackbar = (String message) async {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(translate(message))));
            return Future.value();
          };
          return child!;
        },
      ),
    );
  }
}
