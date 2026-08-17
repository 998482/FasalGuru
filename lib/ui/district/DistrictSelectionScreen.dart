import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/main.dart';
import 'package:fasalguru/model/district/DistrictSelectionModel.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/viewModel/district/DistrictViewModel.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DistrictSelectionScreen extends StatefulWidget {
  const DistrictSelectionScreen({super.key});

  @override
  State<DistrictSelectionScreen> createState() =>
      _DistrictSelectionScreenState();
}

class _DistrictSelectionScreenState extends State<DistrictSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _card1Fade;
  late final Animation<double> _card2Fade;
  late final Animation<double> _buttonFade;

  District? _pending;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_headerFade);

    _card1Fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
    );
    _card2Fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
    );
    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelect(District district) {
    HapticFeedback.selectionClick();
    setState(() => _pending = district);
  }

  void _onContinue(BuildContext context) async {
    if (_pending == null) return;

    final model = _pending == District.lucknow
        ? DistrictSelectionModel.lucknow()
        : DistrictSelectionModel.sitapur();

    // Store app-wide so any screen can read it via Provider.
    context.read<DistrictViewModel>().selectDistrict(model);

    // Save to SharedPref + Firebase
    final profileVM = context.read<ProfileViewmodel>();
    await profileVM.saveDistrictEverywhere(model.district.name);

    // Router ko batao ki district ab set ho chuka hai, taaki
    // redirect logic dobara fresh evaluate ho (GoRouter's
    // refreshListenable startupState sun raha hai).
    startupState.setHasDistrict(true);

    if (!context.mounted) return;

    context.go(Approutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  _StepDot(active: true),
                  const SizedBox(width: 6),
                  _StepDot(active: false),
                  const SizedBox(width: 6),
                  _StepDot(active: false),
                  const Spacer(),
                  Text(
                    l10n.stepOneOfThree,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: colors.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.locationSectionLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: const Color(0xFFD3AF54),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.whereIsYourFarm,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.tailorAdviceDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withOpacity(0.6),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: _card1Fade,
                child: _DistrictCard(
                  title: l10n.lucknow,
                  subtitle: l10n.lucknowSubtitle,
                  icon: Icons.eco_rounded,
                  isSelected: _pending == District.lucknow,
                  onTap: () => _onSelect(District.lucknow),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _card2Fade,
                child: _DistrictCard(
                  title: l10n.sitapur,
                  subtitle: l10n.sitapurSubtitle,
                  icon: Icons.grass_rounded,
                  isSelected: _pending == District.sitapur,
                  onTap: () => _onSelect(District.sitapur),
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _buttonFade,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _pending == null ? 0.45 : 1.0,
                    child: ElevatedButton(
                      onPressed: _pending == null ? null : () => _onContinue(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3AF54),
                        foregroundColor: const Color(0xFF1D4D38),
                        disabledBackgroundColor: const Color(0xFFD3AF54),
                        disabledForegroundColor: const Color(0xFF1D4D38),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.continueButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1D4D38) : const Color(0xFFE3E0CF),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _DistrictCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DistrictCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DistrictCard> createState() => _DistrictCardState();
}

class _DistrictCardState extends State<_DistrictCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1D4D38);
    const gold = Color(0xFFD3AF54);

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: '${widget.title}, ${widget.subtitle}',
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : (widget.isSelected ? 1.01 : 1.0),
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.isSelected ? green.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected ? gold : const Color(0xFFE3E0CF),
                width: widget.isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? gold.withOpacity(0.18)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: widget.isSelected ? 20 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: green, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2923),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF1F2923).withOpacity(0.55),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedScale(
                  scale: widget.isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, size: 15, color: green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}