import 'package:flutter/material.dart';

class SoilCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SoilCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
          CircleAvatar(
  radius: 28,
  backgroundColor: theme.colorScheme.primary,
  child: Icon(
    icon,
    size: 30,
    color: Colors.white,
  ),
),

            const SizedBox(height: 14),

            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 10),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              )
          ],
        ),
      ),
    );
  }
}