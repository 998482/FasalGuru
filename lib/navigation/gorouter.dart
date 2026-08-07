import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/authentication/loginScreen.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/home_screen.dart';
import 'package:fasalguru/ui/location/LocationScreen.dart';
import 'package:fasalguru/ui/onboarding/OnnboardingScreen.dart';
import 'package:fasalguru/ui/outputScreen/output_screen.dart';

import 'package:fasalguru/ui/splash/SplashScreen1.dart';

import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  initialLocation: Approutes.splash1,
  routes: [
    GoRoute(
      path: Approutes.splash1,
      builder: (context, state) {
        return SplashScreen1();
      },
    ),

    GoRoute(
      path: Approutes.login,
      builder: (context, state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      path: Approutes.location,
      builder: (context, state) {
        return locationScreen();
      },
    ),

    GoRoute(
      path: Approutes.onboarding,
      builder: (context, state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      path: Approutes.home,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
   GoRoute(
  path: Approutes.recommendation,
  builder: (context, state) {

    final data = state.extra as Map<String, dynamic>;

    return OutputScreen(
      cropDropdownValue: data['crop'],
      soilCardValue: data['soil'],
      sowingDate: data['date'],
    );
  },
),
  ],
);
