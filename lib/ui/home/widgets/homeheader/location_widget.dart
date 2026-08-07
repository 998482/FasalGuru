import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Later this value will come from GPS
    const city = "Lucknow";

    return InkWell(
      onTap: () {
        // Later open location selection / permission
      },
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 18,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 4),
          Text(
            city,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}