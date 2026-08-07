import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/repository/GetCrops/CropRepository.dart';
import 'package:flutter/material.dart';

class CropSelectionViewModel extends ChangeNotifier {
  final CropRepository _cropRepository = CropRepository();

  late final List<CropModel> crops;

  CropModel? selectedCrop;

  CropSelectionViewModel() {
    crops = _cropRepository.getCrops();

    if (crops.isNotEmpty) {
      selectedCrop = crops.first;
    }
  }

  void selectCrop(CropModel crop) {
    selectedCrop = crop;
    notifyListeners();
  }
}