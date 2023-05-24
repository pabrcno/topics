import 'package:flutter/material.dart';
import 'package:topics/presentation/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        // Define the default brightness and colors.

        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,

        // Define the default font family.
        //ensure that 'OpenSans' font is available in your pubspec.yaml

        // Define the default TextTheme. Use these to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans'),
        ),

        // This makes the visual density adapt to the platform that you run the app on.
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Set thin white border style
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70, width: 1.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.white)
            .copyWith(secondary: Colors.white)
            .copyWith(secondary: Colors.white),
      ),
      home: const MyHomePage(), // The name of your home screen widget
    );
  }
}
