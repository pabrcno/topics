// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCG9LmrV-BkV-gcjtXWBFc-g3LDLEBsxuM',
    appId: '1:199942357204:web:ce01425cc5dac9726e7b41',
    messagingSenderId: '199942357204',
    projectId: 'topics-860b1',
    authDomain: 'topics-860b1.firebaseapp.com',
    storageBucket: 'topics-860b1.appspot.com',
    measurementId: 'G-43GLPD20TH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAH_GgzhU1gnkjj6LGXo50JGXf302MmEg4',
    appId: '1:199942357204:android:7057f62771b2cb096e7b41',
    messagingSenderId: '199942357204',
    projectId: 'topics-860b1',
    storageBucket: 'topics-860b1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4FySIHK9RFblFoaJzMILfk3lB-R_yU-U',
    appId: '1:199942357204:ios:7e5080d6e6fb8c156e7b41',
    messagingSenderId: '199942357204',
    projectId: 'topics-860b1',
    storageBucket: 'topics-860b1.appspot.com',
    androidClientId: '199942357204-65lfq11ofb02j3g633g639dqoj16tu15.apps.googleusercontent.com',
    iosClientId: '199942357204-lhjpjtm9l974lm55od73v1ja63dgki0m.apps.googleusercontent.com',
    iosBundleId: 'com.example.topics',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4FySIHK9RFblFoaJzMILfk3lB-R_yU-U',
    appId: '1:199942357204:ios:26610b00864eb99d6e7b41',
    messagingSenderId: '199942357204',
    projectId: 'topics-860b1',
    storageBucket: 'topics-860b1.appspot.com',
    androidClientId: '199942357204-65lfq11ofb02j3g633g639dqoj16tu15.apps.googleusercontent.com',
    iosClientId: '199942357204-fefi2a3t2si8u8u29cadu2eqaaavumao.apps.googleusercontent.com',
    iosBundleId: 'com.example.topics.RunnerTests',
  );
}
