import 'package:flutter/material.dart';

class RecommendationViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> generateRecommendation() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();
  }
}