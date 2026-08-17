import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/local/language/language_prefs.dart';
import 'package:fasalguru/main.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/viewModel/locale/LocaleViewModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool fromSettings;
  const LanguageSelectionScreen({super.key, this.fromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // Same URLs used on the Settings screen — keep both in sync if these change.
  static const String _termsUrl =
      "https://sites.google.com/view/fasalguru-terms/home";
  static const String _privacyPolicyUrl =
      "https://sites.google.com/view/fasalguru-privacy/home";

  String _selectedCode = 'en';

  @override
  void initState() {
    super.initState();
    final vm = context.read<LocaleViewModel>();
    _selectedCode = vm.locale.languageCode;
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _onContinue() async {
    final vm = context.read<LocaleViewModel>();
    await vm.setLocale(Locale(_selectedCode));
    await LanguagePrefs.setLanguageSelected(true);

    if (!widget.fromSettings) {
      startupState.setHasSelectedLanguage(true);
    }

    if (!mounted) return;

    if (widget.fromSettings) {
      context.pop();
    } else {
      context.go(Approutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Small logo + "Namaste!" side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/AppLogo.png",
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.languageWelcome,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.selectLanguagePrompt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 32),

              _LanguageCard(
                title: l10n.languageEnglish,
                subtitle: l10n.languageEnglishSubtitle,
                isSelected: _selectedCode == 'en',
                onTap: () => setState(() => _selectedCode = 'en'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                title: l10n.languageHindi,
                subtitle: l10n.languageHindiSubtitle,
                isSelected: _selectedCode == 'hi',
                onTap: () => setState(() => _selectedCode = 'hi'),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  child: Text(
                    l10n.continueButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // "I read and accept the terms of use and the privacy policy."
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                          fontSize: 13,
                        ),
                    children: [
                      TextSpan(text: l10n.termsPrefix),
                      TextSpan(
                        text: l10n.termsOfUse,
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_termsUrl),
                      ),
                      TextSpan(text: l10n.termsAnd),
                      TextSpan(
                        text: l10n.privacyPolicyLink,
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_privacyPolicyUrl),
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1D4D38);
    const gold = Color(0xFFD3AF54);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? green.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? gold : const Color(0xFFE3E0CF),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2923),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF1F2923).withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? gold : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}