import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:topics/repo/chat/firestore_chat_repository.dart';
import 'package:topics/repo/user/firestore_user_repo.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';

import 'api/chat/chat_api.dart';
import 'api/image_generation/image_generation_api.dart';
import 'app/chat/chat_provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<LocalizationDelegate> setupLocalizationDelegate() async {
  var localizationDelegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'es']);

  return localizationDelegate;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // Activating App Check
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );

  await dotenv.load(fileName: ".env");
  var localizationDelegate = await setupLocalizationDelegate();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  final AuthService authService = AuthService();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatProvider>(
            create: (context) => ChatProvider(
              chatRepository: FirestoreChatRepository(),
              userRepository: FirestoreUserRepository(),
              imageGenerationApi: ImageGenerationApi(),
              authServiceProvider: authService,
              chatApi: ChatApi(authService),
            ),
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
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
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
