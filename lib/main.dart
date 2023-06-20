// import 'dart:convert';

// // import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:home_widget/home_widget.dart';

// import 'package:json_theme/json_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:topics/repo/chat/firestore_chat_repository.dart';
// import 'package:topics/repo/user/firestore_user_repo.dart';
// import 'package:topics/services/auth/auth_service.dart';
// import 'package:topics/services/exception_handling_service.dart';
// import 'package:workmanager/workmanager.dart';

// import 'api/chat/chat_api.dart';
// import 'api/image_generation/image_generation_api.dart';
// import 'app/chat/chat_provider.dart';
// import 'app/theme/theme_provider.dart';
// import 'firebase_options.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final navigatorKey = GlobalKey<NavigatorState>();
// Future<LocalizationDelegate> setupLocalizationDelegate() async {
//   var localizationDelegate = await LocalizationDelegate.create(
//       fallbackLocale: 'en_US', supportedLocales: ['en_US', 'es']);

//   return localizationDelegate;
// }

// /// Used for Background Updates using Workmanager Plugin
// @pragma("vm:entry-point")
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     final now = DateTime.now();
//     return Future.wait<bool?>([
//       HomeWidget.saveWidgetData(
//         'title',
//         'Updated from Background',
//       ),
//       HomeWidget.saveWidgetData(
//         'message',
//         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
//       ),
//       HomeWidget.updateWidget(
//         name: 'HomeWidgetExampleProvider',
//         iOSName: 'HomeWidgetExample',
//       ),
//     ]).then((value) {
//       return !value.contains(false);
//     });
//   });
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
//   // await FirebaseAppCheck.instance.activate(
//   //   androidProvider: AndroidProvider.debug,
//   // );

//   await dotenv.load(fileName: ".env");
//   var localizationDelegate = await setupLocalizationDelegate();

//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String themePath = prefs.getString('themePath') ?? 'assets/light_theme.json';
//   String logoUrl =
//       prefs.getString('logoUrl') ?? 'assets/images/topics_light_removebg.png';

//   final themeStr = await rootBundle.loadString(themePath);
//   final themeJson = jsonDecode(themeStr);
//   final theme = ThemeDecoder.decodeThemeData(themeJson)!;
//   final AuthService authService = AuthService();
//   runApp(
//     MultiProvider(
//         providers: [
//           ChangeNotifierProvider<ChatProvider>(
//             create: (context) => ChatProvider(
//               chatRepository: FirestoreChatRepository(),
//               userRepository: FirestoreUserRepository(),
//               imageGenerationApi: ImageGenerationApi(),
//               authServiceProvider: authService,
//               chatApi: ChatApi(authService),
//             ),
//           ),
//           ChangeNotifierProvider<ThemeProvider>(
//             create: (context) => ThemeProvider(
//                 initialThemeData: theme,
//                 initialLogoUrl: logoUrl,
//                 initialThemePath: themePath,
//                 prefs: prefs),
//           ),
//         ],
//         child: MyApp(
//           localizationDelegate: localizationDelegate,
//         )),
//   );
// }

// class MyApp extends StatelessWidget {
//   final LocalizationDelegate localizationDelegate;
//   const MyApp({
//     Key? key,
//     required this.localizationDelegate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return LocalizedApp(
//       localizationDelegate,
//       MaterialApp(
//         navigatorKey: navigatorKey,
//         home: AuthService().handleAuthState(),
//         theme: themeProvider.themeData,
//         localizationsDelegates: [
//           localizationDelegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: localizationDelegate.supportedLocales,
//         locale: localizationDelegate.currentLocale,
//         debugShowCheckedModeBanner: false,
//         builder: (context, child) {
//           ErrorCommander.showSnackbar = (String message) async {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(translate(message))));
//             return Future.value();
//           };
//           return child!;
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

/// Used for Background Updates using Workmanager Plugin
final navigatorKey = GlobalKey<NavigatorState>();

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ),
      HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        iOSName: 'HomeWidgetExample',
      ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  print(data);

  if (data?.host == 'titleclicked') {
    final greetings = [
      'Hello',
      'Hallo',
      'Bonjour',
      'Hola',
      'Ciao',
      '哈洛',
      '안녕하세요',
      'xin chào'
    ];
    final selectedGreeting = greetings[Random().nextInt(greetings.length)];

    await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
    await HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future _sendData() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', _titleController.text),
        HomeWidget.saveWidgetData<String>('message', _messageController.text),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
            .then((value) => _titleController.text = value ?? ''),
        HomeWidget.getWidgetData<String>('message',
                defaultValue: 'Default Message')
            .then((value) => _messageController.text = value ?? ''),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
                title: Text('App started from HomeScreenWidget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  void _startBackgroundUpdate() {
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: Duration(minutes: 15));
  }

  void _stopBackgroundUpdate() {
    Workmanager().cancelByUniqueName('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeWidget Example'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Title',
              ),
              controller: _titleController,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Body',
              ),
              controller: _messageController,
            ),
            ElevatedButton(
              onPressed: _sendAndUpdate,
              child: Text('Send Data to Widget'),
            ),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Load Data'),
            ),
            ElevatedButton(
              onPressed: _checkForWidgetLaunch,
              child: Text('Check For Widget Launch'),
            ),
            if (Platform.isAndroid)
              ElevatedButton(
                onPressed: _startBackgroundUpdate,
                child: Text('Update in background'),
              ),
            if (Platform.isAndroid)
              ElevatedButton(
                onPressed: _stopBackgroundUpdate,
                child: Text('Stop updating in background'),
              )
          ],
        ),
      ),
    );
  }
}
