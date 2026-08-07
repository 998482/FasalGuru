import 'current_weather_model.dart';
import 'weather_day_model.dart';

class WeatherResponseModel {
  final CurrentWeatherModel current;
  final List<WeatherDayModel> daily;

  WeatherResponseModel({
    required this.current,
    required this.daily,
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {

    final current =
        CurrentWeatherModel.fromJson(json["current"]);

    final dailyJson = json["daily"];

    List<WeatherDayModel> weatherList = [];

    for (int i = 0; i < dailyJson["time"].length; i++) {

      weatherList.add(

        WeatherDayModel(

          date: dailyJson["time"][i],

          tempMax:
          (dailyJson["temperature_2m_max"][i] ?? 0).toDouble(),

          tempMin:
          (dailyJson["temperature_2m_min"][i] ?? 0).toDouble(),

          rain:
          (dailyJson["rain_sum"][i] ?? 0).toDouble(),

          precipitationProbability:
          dailyJson["precipitation_probability_max"][i] ?? 0,

          windSpeed:
          (dailyJson["wind_speed_10m_max"][i] ?? 0).toDouble(),

          et0:
          (dailyJson["et0_fao_evapotranspiration"][i] ?? 0).toDouble(),
        ),

      );

    }

    return WeatherResponseModel(
      current: current,
      daily: weatherList,
    );
  }
}