import 'package:dart_openai/dart_openai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<void> initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getApiKey() {
    return _prefs.getString('apiKey');
  }

  Future<bool> saveApiKey(String apiKey) async {
    OpenAI.apiKey = apiKey;

    return await _prefs.setString('apiKey', apiKey);
  }

  Future<bool> clearApiKey() async {
    OpenAI.apiKey = '';

    return await _prefs.remove('apiKey');
  }
}

final storageServiceProvider = StorageService();
