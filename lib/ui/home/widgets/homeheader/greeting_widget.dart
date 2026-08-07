import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Later username will come from SharedPreferences/Firebase
    const String username = "Vikas";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Namaste,",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              username,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              "👋",
              style: TextStyle(fontSize: 26),
            )
          ],
        )
      ],
    );
  }
}