// services/irrigation/irrigation_engine_service.dart
//
// Ye file pichli irrigation_engine.dart (pure FAO-56 math) ko wrap karti hai
// aur UI ke liye Hindi text + soil-type/crop-name mapping add karti hai.
// irrigation_engine.dart isi folder me copy kar dena, import wahi se hoga.

import 'irrigation_engine.dart'; // pichli file: cropStages, runDailyCheck, etc.
import '../../model/irrigationmodel/irrigation_result_model.dart';

class IrrigationEngineService {
  // ---- UI dropdown/card values -> internal keys ----

static const Map<String, String> cropNameMap = {
  'wheat': 'wheat',
  'maize': 'maize',
  'chickpea': 'chickpea',
  'lentil': 'lentil',
  'mustard': 'mustard',
  'mungbean': 'mungbean',
  'sugarcane': 'sugarcane',
};

  // Screenshot ke 3 soil cards -> soil texture keys jo irrigation_engine.dart samjhta hai
  static const Map<String, String> soilCardMap = {
  'dry': 'sandy',
  'normal': 'loam',
  'wet': 'clay_loam',
};
  // Stage index (0=initial,1=dev,2=mid,3=late) -> Hindi label per crop family
// Stage index (0=initial,1=dev,2=mid,3=late)
static const List<String> stageNamesHindi = [
  'Germination Stage',
  'Growth Stage',
  'Flowering Stage',
  'Maturity Stage',
];

  /// Main entry point — UI se yahi call karo
  IrrigationResultModel getDailyRecommendation({
    required String cropDropdownValue,  // e.g. 'gehun'
    required String soilCardValue,      // e.g. 'aam_mitti'
    required DateTime sowingDate,
    required double et0,
    required double rainfallMm,
    required double previousDeficitMm,
  }) {
    final cropKey = cropNameMap[cropDropdownValue.toLowerCase()];
    final soilKey = soilCardMap[soilCardValue.toLowerCase()];
    if (cropKey == null) {
      throw ArgumentError('Unknown crop: $cropDropdownValue');
    }
    if (soilKey == null) {
      throw ArgumentError('Unknown soil card: $soilCardValue');
    }

    final crop = cropStages[cropKey]!;
    final daysSinceSowing = DateTime.now().difference(sowingDate).inDays;
    final stageIdx = getStageIndex(crop, daysSinceSowing);

    final result = runDailyCheck(
      cropName: cropKey,
      daysSinceSowing: daysSinceSowing,
      et0: et0,
      rainfallMm: rainfallMm,
      previousDeficitMm: previousDeficitMm,
      soilTexture: soilKey,
    );

    return IrrigationResultModel(
      irrigate: result.irrigate,
      depletionMm: result.depletionMm,
      rawMm: result.rawMm,
      tawMm: result.tawMm,
      etcMm: result.etcMm,
      stageNameHindi: stageNamesHindi[stageIdx],
      headlineHindi: result.irrigate ? 'Aaj paani dein' : 'Aaj paani na dein',
      subTextHindi: _buildSubText(result.irrigate, soilKey),
      reasonHindi: _buildReason(result.irrigate, rainfallMm, soilKey),
    );
  }

 String _buildSubText(bool irrigate, String soilKey) {
  if (!irrigate) {
    return 'The soil currently has enough moisture.';
  }

  if (soilKey == 'sandy') {
    return 'Apply light irrigation more frequently.';
  }

  if (soilKey == 'clay_loam' || soilKey == 'clay') {
    return 'Apply a small amount of irrigation.';
  }

  return 'Apply a moderate amount of irrigation.';
}

String _buildReason(bool irrigate, double rainfallMm, String soilKey) {
  if (!irrigate) {
    return 'The soil moisture is sufficient. Irrigation is not required today.';
  }

  if (rainfallMm < 1.0) {
    return 'There has been little or no rainfall recently, so the soil moisture has decreased.';
  }

  return 'Recent rainfall was insufficient to meet the crop water requirement.';
}
}