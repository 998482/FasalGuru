import 'package:shared_preferences/shared_preferences.dart';

class LanguagePrefs {
  static const _key = 'language_selected';

  static Future<bool> isLanguageSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setLanguageSelected(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}