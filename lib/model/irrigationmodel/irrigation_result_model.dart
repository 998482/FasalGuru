// model/irrigationmodel/irrigation_result_model.dart

class IrrigationResultModel {
  final bool irrigate;
  final double depletionMm;
  final double rawMm;
  final double tawMm;
  final double etcMm;
  final String stageNameHindi;   // "Baaliyan aane ka samay" jaisa - output screen pe dikhega
  final String headlineHindi;    // "Aaj paani dein" / "Aaj paani na dein"
  final String subTextHindi;     // "Zyada matra mein sinchai karein" jaisa
  final String reasonHindi;      // "Kyun?" box ka content

  IrrigationResultModel({
    required this.irrigate,
    required this.depletionMm,
    required this.rawMm,
    required this.tawMm,
    required this.etcMm,
    required this.stageNameHindi,
    required this.headlineHindi,
    required this.subTextHindi,
    required this.reasonHindi,
  });
}