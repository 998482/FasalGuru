import 'dart:io';

import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/services/firebase/firebaseService.dart';
import 'package:fasalguru/ui/Widgets/customBackButton.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/fasalGuruAppbar.dart';
import 'package:fasalguru/viewModel/AuthenticationViewModel/authViewModel.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    final profileView = context.watch<ProfileViewmodel>();
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackbutton(
          pressed: () => context.pop(),
        ),
        title: Text(l10n.settings),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.eco_outlined, color: scheme.onPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProfileRow(
                imagePath: profileView.imagePath,
                name: profileView.profile?.username ?? l10n.fullName,
              ),
              const SizedBox(height: 32),
              _PreferencesCard(
                notificationEnabled: notification,
                onNotificationChanged: (value) {
                  setState(() => notification = value);
                },
              ),
              const SizedBox(height: 20),
              const _AboutCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Shared link opener ----------------

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ---------------- Profile Row ----------------

class _ProfileRow extends StatelessWidget {
  final String? imagePath;
  final String name;

  const _ProfileRow({required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullImage(context),
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.tertiary, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: imagePath != null
                    ? Image.file(File(imagePath!), fit: BoxFit.cover)
                    : Container(
                        color: scheme.secondary.withOpacity(0.15),
                        child: Icon(
                          Icons.person,
                          size: 34,
                          color: scheme.primary,
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context) {
    if (imagePath == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(File(imagePath!), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// ---------------- Preferences Card (Notifications + Policy links) ----------------

class _PreferencesCard extends StatelessWidget {
  final bool notificationEnabled;
  final ValueChanged<bool> onNotificationChanged;

  const _PreferencesCard({
    required this.notificationEnabled,
    required this.onNotificationChanged,
  });

  static const String _privacyPolicyUrl =
      "https://sites.google.com/view/fasalguru-privacy/home";

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return _SettingsCard(
      children: [
        Row(
          children: [
            Icon(Icons.notifications_none_rounded, color: scheme.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.notifications,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: scheme.onSurface,
                ),
              ),
            ),
            Switch(
              value: notificationEnabled,
              activeTrackColor: scheme.primary,
              inactiveTrackColor: Colors.grey.shade400,
              inactiveThumbColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onNotificationChanged,
            ),
          ],
        ),
        const _CardDivider(),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: l10n.privacyPolicy,
          onTap: () => _openUrl(_privacyPolicyUrl),
        ),
        const _CardDivider(),
        _SettingsTile(
          icon: Icons.lock_outline,
          label: l10n.dataSecurity,
          onTap: () => _openUrl(_privacyPolicyUrl),
        ),
      ],
    );
  }
}

// ---------------- About Card (Terms, About, Delete, Logout) ----------------

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  static const String _termsUrl =
      "https://sites.google.com/view/fasalguru-terms/home";

  void _showAboutUs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.aboutFasalGuru),
        content: SingleChildScrollView(
          child: Text(l10n.aboutFasalGuruDescription),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              final authVM = context.read<AuthViewModel>();
              final uid = authVM.getCredential()?.uid;

              Navigator.pop(dialogContext); // dialog band karo pehle

              if (uid != null) {
                await FirebaseService().deleteUserData(uid);
              }
              final success = await authVM.deleteAccount();

              if (success && context.mounted) {
                context.go(Approutes.onboarding);
              } else if (context.mounted && authVM.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authVM.error!)),
                );
              }
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.description_outlined,
          label: l10n.termsAndConditions,
          onTap: () => _openUrl(_termsUrl),
        ),
        const _CardDivider(),
        _SettingsTile(
          icon: Icons.info_outline,
          label: l10n.aboutUs,
          onTap: () => _showAboutUs(context),
        ),
        const _CardDivider(),
        _SettingsTile(
          icon: Icons.person_remove_outlined,
          label: l10n.deleteAccount,
          isDanger: true,
          onTap: () => _confirmDelete(context),
        ),
        const SizedBox(height: 24),
        Center(
          child: _LogoutButton(
            onTap: () async {
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                context.go(Approutes.onboarding);
              }
            },
          ),
        ),
      ],
    );
  }
}

// ---------------- Reusable pieces ----------------

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1D7D3), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Color(0xFFD1D7D3), height: 1),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isDanger ? scheme.error : scheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: isDanger ? scheme.error : scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurface.withOpacity(0.4),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 150,
      height: 42,
      child: Material(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: scheme.onPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.logout,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}