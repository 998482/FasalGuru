import 'package:flutter/material.dart';

class SoilCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const SoilCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
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
            ClipOval(
              child: Container(
                width: 56,
                height: 56,
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(.12)
                    : Colors.grey.shade100,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                ),
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