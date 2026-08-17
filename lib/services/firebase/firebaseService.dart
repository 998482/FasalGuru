import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasalguru/model/profile/Profilemodel%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';



class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserCredential> register(String email, String password) async {
    final output = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return output;
  }

  Future<UserCredential> login(String email, String password) async {
    final output = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return output;
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ---------------- PROFILE ----------------

  /// Uploads profile image to Firebase Storage and returns download URL
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    final ref = _storage.ref().child("profile_images/$uid.jpg");
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    return url;
  }

  /// Saves (creates or updates) profile in Firestore -> users/{uid}
  Future<void> saveProfile(ProfileModel profile) async {
    await db.collection("users").doc(profile.uid).set(
          profile.toMap(),
          SetOptions(merge: true),
        );
  }
  Future<void> deleteUserData(String uid) async {
  await db.collection("users").doc(uid).delete();
}

  /// Fetches profile from Firestore. Returns null if not found.
  Future<ProfileModel?> getProfile(String uid) async {
    final doc = await db.collection("users").doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProfileModel.fromMap(doc.data()!);
  }
}