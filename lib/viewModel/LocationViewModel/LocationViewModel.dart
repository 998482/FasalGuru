import 'package:fasalguru/model/LocationModel/LocationHandler.dart';
import 'package:fasalguru/repository/geoLocation/LocationRepository.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fasalguru/model/LocationModel/LocationHandler.dart';
import 'package:fasalguru/repository/geoLocation/LocationRepository.dart';

class LocationViewModel extends ChangeNotifier {

  final Locationrepository _locationRepository = Locationrepository();

  LocationHandler? location;

  bool isLoading = false;

  String? errorMessage;

  Future<void> fetchLocation() async {

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      location = await _locationRepository.getCurrentLocation();

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;
      notifyListeners();

    }
  }

  void clearLocation() {

    location = null;
    errorMessage = null;
    notifyListeners();

  }
}