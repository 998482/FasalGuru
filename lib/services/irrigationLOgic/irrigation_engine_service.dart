// services/irrigation/irrigation_engine_service.dart
//
// Ye file pichli irrigation_engine.dart (pure FAO-56 math) ko wrap karti hai
// aur UI ke liye English + Hindi text + soil-type/crop-name mapping add karti hai.
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

  // Stage index (0=initial,1=dev,2=mid,3=late)
  static const List<String> stageNamesEnglish = [
    'Germination Stage',
    'Growth Stage',
    'Flowering Stage',
    'Maturity Stage',
  ];

  // FIX: pehle ye list "stageNamesHindi" naam se thi lekin English text
  // rakhti thi — ab actual Hindi (Devanagari) hai.
  static const List<String> stageNamesHindi = [
    'अंकुरण अवस्था',
    'वृद्धि अवस्था',
    'फूल आने की अवस्था',
    'पकने की अवस्था',
  ];

  /// Main entry point — UI se yahi call karo
  IrrigationResultModel getDailyRecommendation({
    required String cropDropdownValue, // e.g. 'gehun'
    required String soilCardValue, // e.g. 'aam_mitti'
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

      stageNameEnglish: stageNamesEnglish[stageIdx],
      stageNameHindi: stageNamesHindi[stageIdx],

      headlineEnglish: result.irrigate ? 'Water your field today' : 'No need to water today',
      headlineHindi: result.irrigate ? 'आज पानी दें' : 'आज पानी न दें',

      subTextEnglish: _buildSubTextEnglish(result.irrigate, soilKey),
      subTextHindi: _buildSubTextHindi(result.irrigate, soilKey),

      reasonEnglish: _buildReasonEnglish(result.irrigate, rainfallMm),
      reasonHindi: _buildReasonHindi(result.irrigate, rainfallMm),
    );
  }

  String _buildSubTextEnglish(bool irrigate, String soilKey) {
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

  String _buildSubTextHindi(bool irrigate, String soilKey) {
    if (!irrigate) {
      return 'मिट्टी में अभी पर्याप्त नमी है।';
    }
    if (soilKey == 'sandy') {
      return 'हल्की सिंचाई अधिक बार करें।';
    }
    if (soilKey == 'clay_loam' || soilKey == 'clay') {
      return 'थोड़ी मात्रा में सिंचाई करें।';
    }
    return 'सामान्य मात्रा में सिंचाई करें।';
  }

  String _buildReasonEnglish(bool irrigate, double rainfallMm) {
    if (!irrigate) {
      return 'The soil moisture is sufficient. Irrigation is not required today.';
    }
    if (rainfallMm < 1.0) {
      return 'There has been little or no rainfall recently, so the soil moisture has decreased.';
    }
    return 'Recent rainfall was insufficient to meet the crop water requirement.';
  }

  String _buildReasonHindi(bool irrigate, double rainfallMm) {
    if (!irrigate) {
      return 'मिट्टी में पर्याप्त नमी है। आज सिंचाई की आवश्यकता नहीं है।';
    }
    if (rainfallMm < 1.0) {
      return 'हाल ही में बहुत कम या बिलकुल बारिश नहीं हुई है, इसलिए मिट्टी की नमी कम हो गई है।';
    }
    return 'हाल की बारिश फ़सल की पानी की ज़रूरत पूरी करने के लिए पर्याप्त नहीं थी।';
  }
}