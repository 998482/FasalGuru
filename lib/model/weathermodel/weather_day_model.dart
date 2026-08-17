class WeatherDayModel {
  final String date;
  final double tempMax;
  final double tempMin;
  final double rain;
  final int precipitationProbability;
  final double windSpeed;
  final double et0;
  final int weatherCode;

  WeatherDayModel({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rain,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.et0,
    required this.weatherCode,
  });
}