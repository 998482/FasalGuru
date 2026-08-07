import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:flutter/material.dart';


class CropTileWidget extends StatelessWidget {
  final CropModel crop;
  final bool selected;
  final VoidCallback onTap;

  const CropTileWidget({
    super.key,
    required this.crop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                crop.image,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.agriculture,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                crop.name,
                style: theme.textTheme.titleMedium,
              ),
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : const SizedBox(
                      width: 28,
                      height: 28,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}