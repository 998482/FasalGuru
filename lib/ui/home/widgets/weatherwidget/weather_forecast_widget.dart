import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'weather_day_card.dart';
import 'weather_icon_helper.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<WeatherViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const SizedBox(
            height: 145,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (vm.weatherList.isEmpty) {
          return SizedBox(
            height: 145,
            child: Center(
              child: Text(l10n.weatherNotAvailable),
            ),
          );
        }

        return SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vm.weatherList.length,
            itemBuilder: (context, index) {
              final weather = vm.weatherList[index];

              return WeatherDayCard(
                day: index == 0
                    ? l10n.today
                    : _getDayName(l10n, weather.date),

                temperature: "${weather.tempMax.round()}°",

                // BUG FIX: was hardcoded to Icons.wb_sunny before —
                // now actually maps the WMO weather code to the right icon.
                // ⚠️ Agar tumhare weather model mein is field ka naam
                // "weatherCode" nahi hai (e.g. "code" ya "wmoCode" hai),
                // to sirf niche wali line change karo.
              icon: WeatherIconHelper.getIcon(weather.weatherCode),

                isSelected: index == 0,
              );
            },
          ),
        );
      },
    );
  }

  String _getDayName(AppLocalizations l10n, String date) {
    final d = DateTime.parse(date);

    final days = [
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
      l10n.sun,
    ];

    return days[d.weekday - 1];
  }
}