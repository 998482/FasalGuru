class CurrentWeatherModel {
  final double temperature;
  final int humidity;
  final double rain;
  final int weatherCode;
  final double windSpeed;

  CurrentWeatherModel({
    required this.temperature,
    required this.humidity,
    required this.rain,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: (json["temperature_2m"] ?? 0).toDouble(),
      humidity: json["relative_humidity_2m"] ?? 0,
      rain: (json["rain"] ?? 0).toDouble(),
      weatherCode: json["weather_code"] ?? 0,
      windSpeed: (json["wind_speed_10m"] ?? 0).toDouble(),
    );
  }
}