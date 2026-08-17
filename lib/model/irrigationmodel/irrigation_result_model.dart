// model/irrigationmodel/irrigation_result_model.dart

class IrrigationResultModel {
  final bool irrigate;
  final double depletionMm;
  final double rawMm;
  final double tawMm;
  final double etcMm;

  final String stageNameEnglish; // "Flowering Stage" jaisa
  final String stageNameHindi;   // "फूल आने की अवस्था" jaisa - output screen pe dikhega

  final String headlineEnglish;  // "Water your field today" / "No need to water today"
  final String headlineHindi;    // "आज पानी दें" / "आज पानी न दें"

  final String subTextEnglish;   // "Apply a moderate amount of irrigation." jaisa
  final String subTextHindi;     // "सामान्य मात्रा में सिंचाई करें।" jaisa

  final String reasonEnglish;    // "Why?" box ka English content
  final String reasonHindi;      // "क्यों?" box ka Hindi content

  IrrigationResultModel({
    required this.irrigate,
    required this.depletionMm,
    required this.rawMm,
    required this.tawMm,
    required this.etcMm,
    required this.stageNameEnglish,
    required this.stageNameHindi,
    required this.headlineEnglish,
    required this.headlineHindi,
    required this.subTextEnglish,
    required this.subTextHindi,
    required this.reasonEnglish,
    required this.reasonHindi,
  });
}