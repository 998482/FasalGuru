import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'weather_day_card.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          return const SizedBox(
            height: 145,
            child: Center(
              child: Text("Weather not available"),
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
                    ? "Today"
                    : _getDayName(weather.date),

                temperature:
                    "${weather.tempMax.round()}°",

                // Filhal fixed icon
                icon: Icons.wb_sunny,

                isSelected: index == 0,
              );
            },
          ),
        );
      },
    );
  }

  String _getDayName(String date) {
    final d = DateTime.parse(date);

    const days = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return days[d.weekday - 1];
  }
}