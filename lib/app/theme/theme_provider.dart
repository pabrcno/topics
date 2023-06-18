import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;

  ThemeProvider({required ThemeData initialThemeData}) {
    _themeData = initialThemeData;
  }
  ThemeData? get themeData => _themeData;

  fetchThemeData(String themePath) async {
    final themeStr = await rootBundle.loadString(themePath);
    final themeJson = jsonDecode(themeStr);
    _themeData = ThemeDecoder.decodeThemeData(themeJson);
    notifyListeners();
  }
}
