// lib/ui/widgets/common/language_toggle_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fasalguru/viewModel/locale/LocaleViewModel.dart';

/// Drop this anywhere in an AppBar's `actions` list.
/// Tap = poora app EN <-> HI switch, kyunki LocaleViewModel
/// notifyListeners() karta hai aur MaterialApp.router ka
/// `locale` property use kar raha hai (main.dart mein already wired hai).
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localeViewModel = context.watch<LocaleViewModel>();
    final isHindi = localeViewModel.isHindi;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.read<LocaleViewModel>().toggleLocale(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD3AF54), // theme tertiary/gold
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  isHindi ? 'हिं' : 'EN',
                  key: ValueKey(isHindi),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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