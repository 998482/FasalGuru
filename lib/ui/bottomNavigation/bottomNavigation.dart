import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  final String currentRoute;

  const AppBottomNavBar({super.key, required this.currentRoute});

  // ---- Define your routes here (match with your gorouter.dart paths) ----
  static String homeRoute = Approutes.home;

  static String cropRoute = Approutes.croprecommendation;   // 👈 FIX: recommendation -> croprecommendation
  static String profileRoute = Approutes.profile;

  int _getSelectedIndex() {
    if (currentRoute.startsWith(homeRoute)) return 0;
    if (currentRoute.startsWith(cropRoute)) return 1;
    if (currentRoute.startsWith(profileRoute)) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(homeRoute);
        break;
      case 1:
        context.go(cropRoute);
        break;
      case 2:
        context.go(profileRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(
                context: context,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: l10n.navHome,
                index: 0,
                selectedIndex: selectedIndex,
              ),
              _navItem(
                context: context,
                icon: Icons.eco_outlined,
                selectedIcon: Icons.eco_rounded,
                label: l10n.navCropAI,
                index: 1,
                selectedIndex: selectedIndex,
              ),
              _navItem(
                context: context,
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: l10n.navProfile,
                index: 2,
                selectedIndex: selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int selectedIndex,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isSelected = selectedIndex == index;
    final Color activeColor = colorScheme.primary; // Deep Forest Green
    final Color inactiveColor = colorScheme.onSurface.withOpacity(0.45);

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.tertiary.withOpacity(0.18) // Gold tint
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}