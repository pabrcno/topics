import 'dart:convert';

// import 'package:firebase_app_check/firebase_app_check.dart';
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
import 'app/store/store_provider.dart';
import 'app/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

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

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  await dotenv.load(fileName: ".env");
  var localizationDelegate = await setupLocalizationDelegate();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String themePath = prefs.getString('themePath') ?? 'assets/light_theme.json';
  String logoUrl =
      prefs.getString('logoUrl') ?? 'assets/images/topics_light_removebg.png';

  final themeStr = await rootBundle.loadString(themePath);
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  final AuthService authService = AuthService();
  await AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'topics_chat_channel',
          channelName: 'Chats',
          channelDescription: 'Chat channel for Topics app',
          playSound: true,
          enableVibration: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.blueGrey.shade900,
          ledColor: Colors.blueGrey.shade900,
        ),
      ],
      debug: true);

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
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(
                initialThemeData: theme,
                initialLogoUrl: logoUrl,
                initialThemePath: themePath,
                prefs: prefs),
          ),
          ChangeNotifierProvider<StoreProvider>(
            create: (context) =>
                StoreProvider(userRepository: FirestoreUserRepository()),
          )
        ],
        child: MyApp(
          localizationDelegate: localizationDelegate,
        )),
  );
}

class MyApp extends StatelessWidget {
  final LocalizationDelegate localizationDelegate;
  const MyApp({
    Key? key,
    required this.localizationDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LocalizedApp(
      localizationDelegate,
      MaterialApp(
        navigatorKey: navigatorKey,
        home: AuthService().handleAuthState(),
        theme: themeProvider.themeData,
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
