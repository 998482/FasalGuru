import 'package:flutter/material.dart';

class WeatherDayCard extends StatelessWidget {
  final String day;
  final String temperature;
  final IconData icon;
  final bool isSelected;

  const WeatherDayCard({
    super.key,
    required this.day,
    required this.temperature,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: isSelected
                ? Colors.white
                : theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 10),
          Text(
            temperature,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            day,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? Colors.white70
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}