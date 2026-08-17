// service/croprecommendation/crop_recommendation_service.dart
//
// Model input order (fixed, training se): [N, P, K, temperature, humidity, ph, rainfall]
// Normalization model ke andar hi bake hai — RAW values do, khud scaling mat karna.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../model/cropmodel/crop_recommendation_result_model.dart';

// ---- Regional soil fallback (jab farmer khud N/P/K/pH na de) ----
// Approximate district averages — exact nahi, farmer ka apna data behtar hai.
class RegionalSoilDefaults {
  final double n;
  final double p;
  final double k;
  final double ph;

  const RegionalSoilDefaults({
    required this.n,
    required this.p,
    required this.k,
    required this.ph,
  });
}

const Map<String, RegionalSoilDefaults> regionalSoilDefaults = {
  'lucknow': RegionalSoilDefaults(n: 65, p: 28, k: 38, ph: 7.4),
  'sitapur': RegionalSoilDefaults(n: 58, p: 24, k: 34, ph: 7.6),
};

const RegionalSoilDefaults _genericUpFallback =
    RegionalSoilDefaults(n: 60, p: 26, k: 36, ph: 7.4);

RegionalSoilDefaults getRegionalDefaults(String district) {
  final key = district.toLowerCase().trim();
  return regionalSoilDefaults[key] ?? _genericUpFallback;
}

class CropRecommendationService {
  Interpreter? _interpreter;
  List<String>? _cropLabels;

  static const Map<String, String> cropNamesEnglish = {
    'apple': 'Apple', 'banana': 'Banana', 'blackgram': 'Black gram',
    'chickpea': 'Chickpea', 'coconut': 'Coconut', 'coffee': 'Coffee',
    'cotton': 'Cotton', 'grapes': 'Grapes', 'jute': 'Jute',
    'kidneybeans': 'Kidney beans', 'lentil': 'Lentil', 'maize': 'Maize',
    'mango': 'Mango', 'mothbeans': 'Moth beans', 'mungbean': 'Mung bean',
    'muskmelon': 'Muskmelon', 'orange': 'Orange', 'papaya': 'Papaya',
    'pigeonpeas': 'Pigeon peas', 'pomegranate': 'Pomegranate', 'rice': 'Rice',
    'watermelon': 'Watermelon',
  };

  static const Map<String, String> cropNamesHindi = {
    'apple': 'सेब', 'banana': 'केला', 'blackgram': 'उड़द',
    'chickpea': 'चना', 'coconut': 'नारियल', 'coffee': 'कॉफ़ी',
    'cotton': 'कपास', 'grapes': 'अंगूर', 'jute': 'जूट',
    'kidneybeans': 'राजमा', 'lentil': 'मसूर', 'maize': 'मक्का',
    'mango': 'आम', 'mothbeans': 'मोठ', 'mungbean': 'मूंग',
    'muskmelon': 'खरबूजा', 'orange': 'संतरा', 'papaya': 'पपीता',
    'pigeonpeas': 'अरहर', 'pomegranate': 'अनार', 'rice': 'चावल',
    'watermelon': 'तरबूज',
  };

  bool get isReady => _interpreter != null && _cropLabels != null;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/crop_recommendation_model.tflite',
    );
    final labelsJson = await rootBundle.loadString(
      'assets/models/crop_labels.json',
    );
    _cropLabels = List<String>.from(json.decode(labelsJson));
  }

  /// Main entry point — ViewModel se yahi call hoga.
  /// n, p, k, ph optional hain — na diye jaayein to district ke average se aa jaayenge.
  CropRecommendationResultModel getRecommendation({
    required String district,
    required double temperature,
    required double humidity,
    required double rainfallMm,
    double? n,
    double? p,
    double? k,
    double? ph,
  }) {
    if (!isReady) {
      throw StateError('Model not loaded — call loadModel() first');
    }

    final defaults = getRegionalDefaults(district);
    final resolvedN = n ?? defaults.n;
    final resolvedP = p ?? defaults.p;
    final resolvedK = k ?? defaults.k;
    final resolvedPh = ph ?? defaults.ph;
    final usedEstimate = n == null || p == null || k == null;

    final input = [
      [resolvedN, resolvedP, resolvedK, temperature, humidity, resolvedPh, rainfallMm],
    ];

    final numClasses = _cropLabels!.length;
    final output = List.filled(1 * numClasses, 0.0).reshape([1, numClasses]);
    _interpreter!.run(input, output);

    final probabilities = List<double>.from(output[0]);
    final indexed = List.generate(
      probabilities.length,
      (i) => MapEntry(i, probabilities[i]),
    )..sort((a, b) => b.value.compareTo(a.value));

    final top = indexed[0];
    final topKey = _cropLabels![top.key];
    final topConfidence = top.value * 100;

   final alternates = indexed.skip(1).take(4).map((e) {   // 2 -> 4
  final key = _cropLabels![e.key];
  return CropSuggestion(
    key: key,
    nameEnglish: cropNamesEnglish[key] ?? key,
    nameHindi: cropNamesHindi[key] ?? key,
    confidence: e.value * 100,
  );
}).toList();

    return CropRecommendationResultModel(
      topCropKey: topKey,
      topCropNameEnglish: cropNamesEnglish[topKey] ?? topKey,
      topCropNameHindi: cropNamesHindi[topKey] ?? topKey,
      topConfidence: topConfidence,
      alternates: alternates,
      headlineEnglish: 'Best crop for your field',
      headlineHindi: 'आपके खेत के लिए सबसे उपयुक्त फ़सल',
      reasonEnglish: _buildReasonEnglish(topConfidence, rainfallMm),
      reasonHindi: _buildReasonHindi(topConfidence, rainfallMm),
      usedEstimatedSoilData: usedEstimate,
    );
  }

  String _buildReasonEnglish(double confidence, double rainfallMm) {
    if (confidence > 85) {
      return 'Your soil, weather, and rainfall are highly suitable for this crop.';
    }
    if (rainfallMm < 20) {
      return 'Given the low rainfall in your area, this crop is a better fit.';
    }
    return 'This crop best matches your current field conditions.';
  }

  String _buildReasonHindi(double confidence, double rainfallMm) {
    if (confidence > 85) {
      return 'आपकी मिट्टी, मौसम और बारिश इस फ़सल के लिए बहुत उपयुक्त हैं।';
    }
    if (rainfallMm < 20) {
      return 'आपके क्षेत्र में कम बारिश को देखते हुए यह फ़सल बेहतर रहेगी।';
    }
    return 'आपके खेत की मौजूदा स्थिति के अनुसार यह सबसे उपयुक्त फ़सल है।';
  }

  void dispose() {
    _interpreter?.close();
  }
}