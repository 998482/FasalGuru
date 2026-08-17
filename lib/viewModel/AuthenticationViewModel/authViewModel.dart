import 'package:fasalguru/repository/authRepo/authRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthViewModel extends ChangeNotifier {
  String? error;
  bool isLoading = false;

  final AuthRepository repo = AuthRepository();

  Future<UserCredential?> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      return await repo.login(email, password);
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> register(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      return await repo.register(email, password);
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repo.logout();
  }

  Future<void> forgotPassword(String email) async {
    await repo.forgotPassword(email);
  }

  User? getCredential() {
    return repo.getCurrentUser();
  }
  Future<bool> deleteAccount() async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    await repo.deleteAccount();
    return true;
  } catch (e) {
    error = e.toString();
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}