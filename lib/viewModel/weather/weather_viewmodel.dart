import 'package:fasalguru/local/current_weather_entity.dart';
import 'package:fasalguru/local/weather_entity.dart';
import 'package:fasalguru/repository/weather/weather_repository.dart';
import 'package:flutter/material.dart';


class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  List<WeatherEntity> _weatherList = [];
  CurrentWeatherEntity? _currentWeather;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<WeatherEntity> get weatherList => _weatherList;

  CurrentWeatherEntity? get currentWeather => _currentWeather;

  Future<void> loadWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // API se data fetch + Room me save
      await _repository.syncWeather(
        latitude: latitude,
        longitude: longitude,
      );

      // Room se data read
      _weatherList = await _repository.getOfflineWeather();

      _currentWeather = await _repository.getCurrentWeather();

    } catch (e) {
      _errorMessage = e.toString();

      // Agar API fail ho jaye to Room se data dikhao
      _weatherList = await _repository.getOfflineWeather();

      _currentWeather = await _repository.getCurrentWeather();

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}