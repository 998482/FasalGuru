// viewModel/irrigation/irrigation_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../repository/irrigation/irrigation_repository.dart';
import '../../model/irrigationmodel/irrigation_result_model.dart';

class IrrigationViewModel extends ChangeNotifier {
  final IrrigationRepository repository;

  IrrigationViewModel({required this.repository});

  bool isLoading = false;
  String? errorMessage;
  IrrigationResultModel? result;

  Future<void> loadRecommendation({
    required String cropDropdownValue,
    required String soilCardValue,
    required DateTime sowingDate,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      result = await repository.getRecommendation(
        cropDropdownValue: cropDropdownValue,
        soilCardValue: soilCardValue,
        sowingDate: sowingDate,
      );
    } catch (e, s) {
  print(e);
  print(s);
  errorMessage = e.toString();

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}