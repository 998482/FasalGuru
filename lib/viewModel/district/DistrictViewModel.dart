import 'package:flutter/material.dart';
import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/model/district/DistrictSelectionModel.dart';

/// Holds the farmer's selected district for the whole app session.
/// Any screen can read this via Provider.of<DistrictViewModel>(context)
/// without needing the object passed manually through routes.
class DistrictViewModel extends ChangeNotifier {
  DistrictSelectionModel? _selectedDistrict;

  DistrictSelectionModel? get selectedDistrict => _selectedDistrict;
  bool get hasSelection => _selectedDistrict != null;

  void selectDistrict(DistrictSelectionModel district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void clearSelection() {
    _selectedDistrict = null;
    notifyListeners();
  }

  /// App restart / splash screen par ek baar call karo.
  /// ProfileViewmodel.saveDistrictEverywhere() se pehle jo district
  /// SharedPrefs (LocationPrefs) me save hua tha, usse wapas session
  /// state me restore karta hai — taaki app dobara khulne par bhi
  /// district selection yaad rahe.
  Future<void> loadSavedDistrict() async {
    final savedName = await LocationPrefs.getDistrict();
    if (savedName == null || savedName.isEmpty) return;

    // "Lucknow" / "Sitapur" jo bhi saved tha, usi ke hisaab se
    // wapas factory constructor se model bana rahe hain.
    final model = savedName.toLowerCase() == 'sitapur'
        ? DistrictSelectionModel.sitapur()
        : DistrictSelectionModel.lucknow();

    _selectedDistrict = model;
    notifyListeners();
  }
}