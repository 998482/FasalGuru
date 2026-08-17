import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'soil_card_widget.dart';

enum SoilType {
  dry,
  normal,
  wet,
}

class SoilSelectionWidget extends StatefulWidget {
  final ValueChanged<SoilType> onSoilSelected;

  const SoilSelectionWidget({
    super.key,
    required this.onSoilSelected,
  });

  @override
  State<SoilSelectionWidget> createState() => _SoilSelectionWidgetState();
}

class _SoilSelectionWidgetState extends State<SoilSelectionWidget> {
  SoilType selected = SoilType.normal;

  @override
  void initState() {
    super.initState();

    // Default value HomeScreen ko bhej do
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSoilSelected(selected);
    });
  }

  void selectSoil(SoilType soil) {
    setState(() {
      selected = soil;
    });

    widget.onSoilSelected(soil);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.howIsYourFieldSoil,
          style: theme.textTheme.titleLarge,
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: SoilCardWidget(
                title: l10n.dry,
                subtitle: l10n.needsIrrigation,
                icon: Icons.wb_sunny,
                isSelected: selected == SoilType.dry,
                onTap: () => selectSoil(SoilType.dry),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: SoilCardWidget(
                title: l10n.normal,
                subtitle: l10n.balanced,
                icon: Icons.grass,
                isSelected: selected == SoilType.normal,
                onTap: () => selectSoil(SoilType.normal),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: SoilCardWidget(
                title: l10n.wet,
                subtitle: l10n.highMoisture,
                icon: Icons.water_drop,
                isSelected: selected == SoilType.wet,
                onTap: () => selectSoil(SoilType.wet),
              ),
            ),
          ],
        ),
      ],
    );
  }
}