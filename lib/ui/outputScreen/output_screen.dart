import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/ui/Widgets/customBackButton.dart';
import 'package:fasalguru/ui/bottomNavigation/bottomNavigation.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/fasalGuruAppbar.dart';
import 'package:fasalguru/viewModel/irrigation/irrigation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OutputScreen extends StatefulWidget {
  final String cropDropdownValue; // 'gehun'
  final String soilCardValue; // 'aam_mitti'
  final DateTime sowingDate;

  const OutputScreen({
    super.key,
    required this.cropDropdownValue,
    required this.soilCardValue,
    required this.sowingDate,
  });

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  bool showTechnical = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IrrigationViewModel>().loadRecommendation(
            cropDropdownValue: widget.cropDropdownValue,
            soilCardValue: widget.soilCardValue,
            sowingDate: widget.sowingDate,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5EDE0); // screenshot ka cream background
    const darkGreen = Color(0xFF1F3D2B);
    const goldText = Color(0xFFC98A2E);

    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: CustomBackbutton(
          pressed: () => context.pop(),
        ),
        backgroundColor: darkGreen,
        title: Text('${widget.cropDropdownValue} — ${l10n.todaysRecommendation}'),
      ),
      body: Consumer<IrrigationViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(child: Text(vm.errorMessage!));
          }
          final result = vm.result;
          if (result == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? result.headlineHindi : result.headlineEnglish,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi ? result.subTextHindi : result.subTextEnglish,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // "Kyun?" / "Why?" box - dark green
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: darkGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.why,
                        style: const TextStyle(color: goldText, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isHindi ? result.reasonHindi : result.reasonEnglish,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fasal ki stage card - white
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.cropGrowthStage,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHindi ? result.stageNameHindi : result.stageNameEnglish,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Zyada jaankari (technical) - expandable
                InkWell(
                  onTap: () => setState(() => showTechnical = !showTechnical),
                  child: Row(
                    children: [
                      Icon(showTechnical ? Icons.expand_less : Icons.chevron_right,
                          size: 18, color: darkGreen),
                      Text(
                        l10n.moreInfoTechnical,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                if (showTechnical)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _techRow(l10n.etcLabel, '${result.etcMm.toStringAsFixed(1)} mm'),
                        _techRow(l10n.depletionLabel, '${result.depletionMm.toStringAsFixed(1)} mm'),
                        _techRow(l10n.rawLabel, '${result.rawMm.toStringAsFixed(1)} mm'),
                        _techRow(l10n.tawLabel, '${result.tawMm.toStringAsFixed(1)} mm'),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _techRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}