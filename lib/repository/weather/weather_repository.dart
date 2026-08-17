import 'package:fasalguru/local/current_weather_entity.dart';
import 'package:fasalguru/local/weather_dao.dart';
import 'package:fasalguru/local/weather_entity.dart';

import 'package:fasalguru/model/weathermodel/weather_response_model.dart';
import 'package:fasalguru/services/weather/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _apiService;
  final WeatherDao _weatherDao;

  WeatherRepository(
    this._apiService,
    this._weatherDao,
  );

  Future<void> syncWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final cachedWeather = await _weatherDao.getFirstWeather();

      if (cachedWeather != null) {
        final lastSync = DateTime.parse(cachedWeather.syncedAt);

        final difference = DateTime.now().difference(lastSync);

        if (difference.inHours < 12) {
          return;
        }
      }
      // API Call
      final response = await _apiService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );

      // JSON -> Model
      final WeatherResponseModel weather =
          WeatherResponseModel.fromJson(response.data);

      // Delete old data
      await _weatherDao.deleteAllWeather();
      await _weatherDao.deleteCurrentWeather();

      // Model -> Entity
      final List<WeatherEntity> weatherList = weather.daily.map((day) {
        return WeatherEntity(
          date: day.date,
          tempMax: day.tempMax,
          tempMin: day.tempMin,
          rain: day.rain,
          precipitation: 0, // Update later if you add precipitation_sum
          precipitationProbability: day.precipitationProbability,
          windSpeed: day.windSpeed,
          et0: day.et0,
          // FIX: yeh line missing thi — isi wajah se icon galat dikhta
          // tha. Model tak weatherCode aa raha tha, lekin DB entity mein
          // kabhi save hi nahi ho raha tha.
          weatherCode: day.weatherCode,
          syncedAt: DateTime.now().toIso8601String(),
        );
      }).toList();

      // Save Daily Weather
      await _weatherDao.insertWeather(weatherList);

      // Save Current Weather
      final currentWeather = CurrentWeatherEntity(
        temperature: weather.current.temperature,
        humidity: weather.current.humidity,
        rain: weather.current.rain,
        weatherCode: weather.current.weatherCode,
        windSpeed: weather.current.windSpeed,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _weatherDao.insertCurrentWeather(currentWeather);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeatherEntity>> getOfflineWeather() async {
    return await _weatherDao.getAllWeather();
  }

  Future<CurrentWeatherEntity?> getCurrentWeather() async {
    return await _weatherDao.getCurrentWeather();
  }
}