import 'package:dio/dio.dart';

class WeatherApiService {
  final Dio _dio;

  WeatherApiService(this._dio);

  Future<Response> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        "https://api.open-meteo.com/v1/forecast",
        queryParameters: {
          "latitude": latitude,
          "longitude": longitude,

          // Current Weather
          "current":
              "temperature_2m,relative_humidity_2m,rain,weather_code,wind_speed_10m",

          // Daily Forecast
          // FIX: "weather_code" add kiya — pehle ye missing tha, isliye
          // API response ke "daily" object mein weather_code array kabhi
          // aata hi nahi tha, aur har din sun icon (fallback 0) dikhta tha.
          "daily":
              "temperature_2m_max,temperature_2m_min,rain_sum,precipitation_probability_max,wind_speed_10m_max,et0_fao_evapotranspiration,weather_code",

          "forecast_days": 14,
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? "Weather API Error",
      );
    }
  }
}