import 'package:shared_preferences/shared_preferences.dart';

class LocationPrefs {
  static const String _keyDistrict = 'selected_district';
  static const String _keyLat = 'last_lat';
  static const String _keyLng = 'last_lng';
  static const String _keySource = 'last_location_source'; // 'gps' or 'district'

  // ---- Save district (onboarding / district selection screen) ----
  static Future<void> saveDistrict(String district) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDistrict, district);
  }

  static Future<String?> getDistrict() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDistrict);
  }

  // ---- Save live GPS coordinates (jab bhi location mile) ----
  static Future<void> saveCoordinates(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat, lat);
    await prefs.setDouble(_keyLng, lng);
    await prefs.setString(_keySource, 'gps');
  }

  static Future<Map<String, double>?> getSavedCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_keyLat);
    final lng = prefs.getDouble(_keyLng);
    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
    return null;
  }

  static Future<String?> getLocationSource() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySource);
  }

  // ---- Clear all (e.g. on logout) ----
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDistrict);
    await prefs.remove(_keyLat);
    await prefs.remove(_keyLng);
    await prefs.remove(_keySource);
  }
  static const String _keyOnboardingDone = 'onboarding_done';

static Future<void> setOnboardingDone() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyOnboardingDone, true);
}

static Future<bool> isOnboardingDone() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_keyOnboardingDone) ?? false;
}
}