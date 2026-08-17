import 'dart:convert';
import 'package:fasalguru/model/profile/Profilemodel .dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefs {
  static const _key = 'cached_profile';

  static Future<void> saveProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'uid': profile.uid,
      'username': profile.username,
      'phoneNumber': profile.phoneNumber,
      'village': profile.village,
      'state': profile.state,
      'imageUrl': profile.imageUrl,
      'updatedAt': profile.updatedAt,
    };
    await prefs.setString(_key, jsonEncode(map));
  }

  static Future<ProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return ProfileModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      village: map['village'] as String,
      state: map['state'] as String,
      imageUrl: map['imageUrl'] as String?,
      updatedAt: map['updatedAt'] as int,
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}