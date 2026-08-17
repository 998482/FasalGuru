import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles app-wide language switching (English <-> Hindi).
/// Registered in main.dart's MultiProvider just like every other
/// ViewModel — one toggle call rebuilds the ENTIRE app via
/// MaterialApp.router's `locale` property.
class LocaleViewModel extends ChangeNotifier {
  static const _prefsKey = 'app_locale_code';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isHindi => _locale.languageCode == 'hi';

  LocaleViewModel() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      _locale = Locale(saved);
      notifyListeners();
    }
  }

  /// Call this from your toggle button.
  Future<void> toggleLocale() async {
    _locale =
        _locale.languageCode == 'en' ? const Locale('hi') : const Locale('en');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _locale.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}