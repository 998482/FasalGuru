import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIconHelper {
  static IconData getIcon(int code) {
    if (code == 0) return WeatherIcons.day_sunny;

    if (code >= 1 && code <= 3) {
      return WeatherIcons.cloud;
    }

    if ((code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82)) {
      return WeatherIcons.rain;
    }

    if (code >= 71 && code <= 86) {
      return WeatherIcons.snow;
    }

    if (code == 45 || code == 48) {
      return WeatherIcons.fog;
    }

    if (code == 95 || code == 96 || code == 99) {
      return WeatherIcons.thunderstorm;
    }

    return WeatherIcons.na;
  }
}