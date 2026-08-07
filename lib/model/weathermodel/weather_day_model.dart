class WeatherDayModel {
  final String date;
  final double tempMax;
  final double tempMin;
  final double rain;
  final int precipitationProbability;
  final double windSpeed;
  final double et0;

  WeatherDayModel({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rain,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.et0,
  });
}