import 'package:fasalguru/model/cropmodel/crop_recommendation_result_model.dart';
import 'package:fasalguru/services/croprecondation/crop_recommendation_service.dart';
import 'package:flutter/foundation.dart';



enum CropRecommendationState { idle, loading, success, error }

class CropRecommendationViewModel extends ChangeNotifier {
  final CropRecommendationService _service = CropRecommendationService();

  CropRecommendationState state = CropRecommendationState.idle;
  CropRecommendationResultModel? result;
  String? errorMessage;

  Future<void> init() async {
    try {
      await _service.loadModel();
    } catch (e) {
      errorMessage = 'Model ldoes not Loaded: $e';
      state = CropRecommendationState.error;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendation({
    required String district,
    required double temperature,
    required double humidity,
    required double rainfallMm,
    double? n,
    double? p,
    double? k,
    double? ph,
  }) async {
    state = CropRecommendationState.loading;
    notifyListeners();

    try {
      result = _service.getRecommendation(
        district: district,
        temperature: temperature,
        humidity: humidity,
        rainfallMm: rainfallMm,
        n: n, p: p, k: k, ph: ph,
      );
      state = CropRecommendationState.success;
    } catch (e) {
      errorMessage = 'Recommendation nahi mil paayi: $e';
      state = CropRecommendationState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}