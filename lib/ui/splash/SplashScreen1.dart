/*import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen1();
  }
}

class _SplashScreen1 extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }
Future<void> _navigate() async {
 

  final onboardingDone = await LocationPrefs.isOnboardingDone();
  final currentUser = FirebaseAuth.instance.currentUser;

  if (!mounted) return;

  if (!onboardingDone) {
    context.go(Approutes.onboarding);
  } else if (currentUser == null) {
    context.go(Approutes.login); // onboarding dekh chuka, but logged in nahi
  } else {
    final profileVM = Provider.of<ProfileViewmodel>(context, listen: false);
    final hasDistrict = await profileVM.hasDistrictSaved();
    if (!mounted) return;
    context.go(hasDistrict ? Approutes.home : Approutes.district);
  }
}
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: colorScheme.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(30),
              child: Image.asset(
                "assets/images/AppLogo.png",
                width: width / 2,
                height: height / 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
