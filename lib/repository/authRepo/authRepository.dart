


import 'package:fasalguru/services/firebase/firebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseService _service = FirebaseService();
  Future<UserCredential> register(String email, String password) async {
    return await _service.register(email, password);
  }

  Future<UserCredential> login(String email, String password) async {
    return await _service.login(email, password);
  }

  Future<void> deleteAccount() async {
    final user = _service.getCurrentUser();
    if (user == null) throw Exception("No user logged in");
    await user.delete();
  }
  Future<void> forgotPassword(String email) async {
    return await _service.forgotPassword(email);
  }

  Future<void> logout() async {
    return await _service.logout();
  }

  User? getCurrentUser() {
    return _service.getCurrentUser();
  }
}
