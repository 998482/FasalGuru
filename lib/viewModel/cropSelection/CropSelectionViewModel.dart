import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/repository/GetCrops/CropRepository.dart';
import 'package:flutter/material.dart';

class CropSelectionViewModel extends ChangeNotifier {
  final CropRepository _cropRepository = CropRepository();

  List<CropModel> crops = [];

  CropModel? selectedCrop;

  String? _lastLanguageCode;

  /// Language badalne par (ya app start ke turant baad) main.dart ka
  /// locale-sync hook ye call karta hai. Purana selected crop (uski id
  /// se) preserve rehta hai, sirf naam naye language mein update hote hain.
  void updateLocale(String languageCode, AppLocalizations l10n) {
    if (_lastLanguageCode == languageCode && crops.isNotEmpty) return;

    _lastLanguageCode = languageCode;

    final previousSelectedId = selectedCrop?.id;

    crops = _cropRepository.getCrops(l10n);

    if (previousSelectedId != null) {
      selectedCrop = crops.firstWhere(
        (c) => c.id == previousSelectedId,
        orElse: () => crops.first,
      );
    } else if (crops.isNotEmpty) {
      selectedCrop = crops.first;
    }

    notifyListeners();
  }

  void selectCrop(CropModel crop) {
    selectedCrop = crop;
    notifyListeners();
  }
}