import 'package:flutter/material.dart';

class WeatherIconHelper {
  static IconData getIcon(int code) {
    // Clear sky
    if (code == 0) {
      return Icons.wb_sunny;
    }

    // Mainly clear, partly cloudy, overcast
    if (code >= 1 && code <= 3) {
      return Icons.cloud;
    }

    // Fog
    if (code == 45 || code == 48) {
      return Icons.foggy;
    }

    // Drizzle + rain
    if ((code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82)) {
      return Icons.water_drop;
    }

    // Snow
    if (code >= 71 && code <= 77) {
      return Icons.ac_unit;
    }

    // Snow showers
    if (code >= 85 && code <= 86) {
      return Icons.ac_unit;
    }

    // Thunderstorm
    if (code >= 95 && code <= 99) {
      return Icons.thunderstorm;
    }

    // Unknown weather code
    return Icons.help_outline;
  }
}