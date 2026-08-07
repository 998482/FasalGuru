import 'package:floor/floor.dart';

@Entity(tableName: "current_weather")
class CurrentWeatherEntity {
  @PrimaryKey()
  final int id;

  final double temperature;

  final int humidity;

  final double rain;

  final int weatherCode;

  final double windSpeed;

  final String updatedAt;

  CurrentWeatherEntity({
    this.id = 1,
    required this.temperature,
    required this.humidity,
    required this.rain,
    required this.weatherCode,
    required this.windSpeed,
    required this.updatedAt,
  });
}