class CropRecommendationResultModel {
  final String topCropKey;          // 'rice' — internal key
  final String topCropNameEnglish;  // 'Rice'
  final String topCropNameHindi;    // 'चावल'
  final double topConfidence;       // 0-100

  final List<CropSuggestion> alternates;

  final String headlineEnglish;
  final String headlineHindi;
  final String reasonEnglish;
  final String reasonHindi;

  final bool usedEstimatedSoilData; // true = N/P/K district-average se aaya, farmer ne nahi diya

  CropRecommendationResultModel({
    required this.topCropKey,
    required this.topCropNameEnglish,
    required this.topCropNameHindi,
    required this.topConfidence,
    required this.alternates,
    required this.headlineEnglish,
    required this.headlineHindi,
    required this.reasonEnglish,
    required this.reasonHindi,
    required this.usedEstimatedSoilData,
  });
}

class CropSuggestion {
  final String key;
  final String nameEnglish;
  final String nameHindi;
  final double confidence;

  CropSuggestion({
    required this.key,
    required this.nameEnglish,
    required this.nameHindi,
    required this.confidence,
  });
}