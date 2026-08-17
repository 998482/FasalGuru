import 'package:floor/floor.dart';

@Entity(tableName: "weather")
class WeatherEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String date;

  final double tempMax;

  final double tempMin;

  final double rain;

  final double precipitation;

  final int precipitationProbability;

  final double windSpeed;

  final double et0;

  final int weatherCode;

  final String syncedAt;

  WeatherEntity({
    this.id,
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rain,
    required this.precipitation,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.et0,
    required this.weatherCode,
    required this.syncedAt,
  });
}