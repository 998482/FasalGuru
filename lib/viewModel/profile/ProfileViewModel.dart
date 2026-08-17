import 'dart:io';

import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/local/profile/profile_prefs.dart';
import 'package:fasalguru/model/profile/Profilemodel%20.dart';
import 'package:fasalguru/services/firebase/firebaseService.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewmodel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  ProfileModel? profile;
  String? imagePath; // locally picked image, before upload
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  final ImagePicker _picker = ImagePicker();

  /// Call this on app open / splash screen once user is authenticated
  Future<void> loadProfile() async {
    final user = _service.getCurrentUser();
    if (user == null) return;

    // 1) Pehle turant local cache se dikhao (Flipkart-style instant load)
    final cached = await ProfilePrefs.getProfile();
    if (cached != null) {
      profile = cached;
      notifyListeners();
    }

    isLoading = profile == null; // cache maujood hai to bada loader mat dikhao
    errorMessage = null;
    notifyListeners();

    // 2) Background mein Firestore se fresh data lao
    try {
      final fresh = await _service.getProfile(user.uid);
      if (fresh != null) {
        profile = fresh;
        await ProfilePrefs.saveProfile(fresh);
      }
    } catch (e) {
      // Agar cache maujood hai to error silently ignore karo,
      // user ko cached data dikhta rahega (offline-friendly)
      if (profile == null) {
        errorMessage = "Profile load nahi ho paya: $e";
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> hasDistrictSaved() async {
    final localDistrict = await LocationPrefs.getDistrict();
    return localDistrict != null;
  }

  Future<void> saveDistrictEverywhere(String district) async {
    await LocationPrefs.saveDistrict(district);
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    final picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked != null) {
      imagePath = picked.path;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String username,
    required String phoneNumber,
    required String village,
    required String state,
  }) async {
    final user = _service.getCurrentUser();
    if (user == null) {
      errorMessage = "User login nahi hai";
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? imageUrl = profile?.imageUrl;

      // Agar naya image select kiya gaya hai, tabhi upload karo
      if (imagePath != null) {
        imageUrl = await _service.uploadProfileImage(
          File(imagePath!),
          user.uid,
        );
      }

      final updatedProfile = ProfileModel(
        uid: user.uid,
        username: username.trim(),
        phoneNumber: phoneNumber.trim(),
        village: village.trim(),
        state: state.trim(),
        imageUrl: imageUrl,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _service.saveProfile(updatedProfile);
      profile = updatedProfile;

      // Local cache bhi update karo taaki agli baar app open hote hi
      // turant ye data dikhe, bina Firestore ka wait kiye
      await ProfilePrefs.saveProfile(updatedProfile);

      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "Profile save nahi ho paya: $e";
      isSaving = false;
      notifyListeners();
      return false;
    }
  }
}