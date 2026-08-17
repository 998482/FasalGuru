import 'dart:io';
import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/Widgets/LanguageToggleButton.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Professional custom AppBar for FasalGuru
/// Usage: Scaffold(appBar: const FasalGuruAppBar(), body: ...)
class FasalGuruAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FasalGuruAppBar({super.key});

  // Real AppBar automatically adds status-bar height on top of this,
  // so overflow nahi hota chahe phone ka notch/status bar chota ho ya bada.
  static const double _toolbarHeight = 78;

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      toolbarHeight: _toolbarHeight,
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      elevation: 0,
       
    
      titleSpacing: 18,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //_ProfileAvatar(),
          HomeIconButton(),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${l10n.namaste},",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Consumer<ProfileViewmodel>(
                  builder: (context, vm, child) {
                    if (vm.isLoading) {
                      return const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    }
                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            vm.profile?.username ?? l10n.user,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text("👋", style: TextStyle(fontSize: 16)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),


         
          const SizedBox(width: 8),

const LanguageToggleButton(),

const SizedBox(width: 8),

          
          _AppBarIconButton(
            icon: Icons.settings_outlined,
            onTap: () => context.push(Approutes.settings),
          ),
     
        
               const SizedBox(width: 8),
          _AppBarIconButton(
            icon: Icons.notifications_none_rounded,
            showBadge: true,
            onTap: () {
              // TODO: navigate to notifications screen
            },
          ),
        ],
      ),
    );
  }
}

// class _ProfileAvatar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileViewmodel>(
//       builder: (context, vm, child) {
//         final scheme = Theme.of(context).colorScheme;

//         return GestureDetector(
//           onTap: () {
//             if (vm.imagePath == null) return;
//             showDialog(
//               context: context,
//               builder: (_) => Dialog(
//                 backgroundColor: Colors.transparent,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.file(File(vm.imagePath!), fit: BoxFit.cover),
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 1.4),
//             ),
//             child: ClipOval(
//               child: vm.imagePath != null
//                   ? Image.file(File(vm.imagePath!), fit: BoxFit.cover)
//                   : Container(
//                       color: scheme.secondary.withOpacity(0.25),
//                       child: Icon(
//                         Icons.person,
//                         size: 20,
//                         color: scheme.onPrimary,
//                       ),
//                     ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 19),
            if (showBadge)
              Positioned(
                top: 7,
                right: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(Approutes.home);
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white,
            width: 1.4,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            "assets/images/AppLogo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}