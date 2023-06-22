import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_theme/json_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;
  String _logoUrl;
  String _themePath;
  SharedPreferences prefs;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ThemeProvider(
      {required ThemeData initialThemeData,
      required String initialLogoUrl,
      required String initialThemePath,
      required this.prefs})
      : _themeData = initialThemeData,
        _logoUrl = initialLogoUrl,
        _themePath = initialThemePath,
        super();

  ThemeData? get themeData => _themeData;
  String get logoUrl => _logoUrl;

  String get themePath => _themePath;

  fetchThemeData(String themePath) async {
    isLoading = true;
    _themePath = themePath;

    final themeStr = await rootBundle.loadString(themePath);
    final themeJson = jsonDecode(themeStr);
    _themeData = ThemeDecoder.decodeThemeData(themeJson);
    if (themePath != 'assets/light_theme.json') {
      _logoUrl = 'assets/images/topics_dark_removebg.png';
    } else {
      _logoUrl = 'assets/images/topics_light_removebg.png';
    }
    isLoading = false;
    await prefs.setString('themePath', themePath);
    await prefs.setString('logoUrl', _logoUrl);
  }
}
