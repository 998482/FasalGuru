import 'package:fasalguru/main.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/authentication/forgetScreen.dart';
import 'package:fasalguru/ui/authentication/loginScreen.dart';
import 'package:fasalguru/ui/authentication/signUpScreen.dart';
import 'package:fasalguru/ui/crop_recommendation/crop_recommendation_screen.dart';
import 'package:fasalguru/ui/district/DistrictSelectionScreen.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/home_screen.dart';
import 'package:fasalguru/ui/language/LanguageSelectionScreen.dart';
import 'package:fasalguru/ui/location/LocationScreen.dart';
import 'package:fasalguru/ui/onboarding/OnnboardingScreen.dart';
import 'package:fasalguru/ui/outputScreen/output_screen.dart';
import 'package:fasalguru/ui/profile/profileScreen.dart';
import 'package:fasalguru/ui/setting/settingScreen.dart';

import 'package:go_router/go_router.dart';

// Signup/forgot-password ko redirect check se exempt rakha hai — auth
// sub-flow ke beech me bounce nahi hona chahiye.
final Set<String> _redirectExemptPaths = {
  Approutes.signup,
  Approutes.forgotPassword,
};

/// main.dart me call hoga: routerConfig: createRouter(startupState)
/// Function isliye taaki main.dart -> gorouter.dart -> main.dart
/// circular import safely chal jaaye (top-level variable read nahi,
/// parameter ke through startupState milta hai).
///
/// refreshListenable: startupState -- IMPORTANT. AppStartupState ab
/// ChangeNotifier hai. Jab bhi login/district/onboarding/language complete
/// hoke startupState update hota hai (notifyListeners), GoRouter redirect
/// dobara evaluate karega with FRESH values -- isse "too many redirects"
/// / stuck-on-screen wala loop fix ho jaata hai.
GoRouter createRouter(AppStartupState startupState) {
  
  return GoRouter(
    initialLocation: Approutes.language,
    refreshListenable: startupState,
    redirect: (context, state) {
      final goingTo = state.matchedLocation;

      if (_redirectExemptPaths.contains(goingTo)) return null;

      // 0) Language select nahi hui -> language screen pe bhejo
      //    (sabse pehle, onboarding se bhi pehle)
      if (!startupState.hasSelectedLanguage) {
        return goingTo == Approutes.language ? null : Approutes.language;
      }

      // 1) Onboarding nahi hua -> onboarding pe bhejo
      if (!startupState.onboardingDone) {
        return goingTo == Approutes.onboarding ? null : Approutes.onboarding;
      }

      // 2) Onboarding done but login nahi hai -> login pe bhejo
      if (!startupState.isLoggedIn) {
        return goingTo == Approutes.login ? null : Approutes.login;
      }

      // 3) Login hai but district select nahi hai -> district pe bhejo
      if (!startupState.hasDistrict) {
        return goingTo == Approutes.district ? null : Approutes.district;
      }

      // 4) Sab set hai -> language/onboarding/login/district pe wapas
      //    mat jaane do (Settings se language screen access karna is
      //    check se exempt hai, kyunki wo context.push use karta hai
      //    aur waha se seedha pop() ho jaata hai — GoRouter redirect
      //    tab bhi trigger hoga, isliye language ko yaha se hata do)
      if (goingTo == Approutes.onboarding ||
          goingTo == Approutes.login ||
          goingTo == Approutes.district) {
        return Approutes.home;
      }

      return null;
    },
    routes: [
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
        path: Approutes.language,
        builder: (context, state) {
          final fromSettings = state.extra == true;
          return LanguageSelectionScreen(fromSettings: fromSettings);
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
        path: Approutes.profile,
        builder: (context, state) {
          return SaveProfileScreen();
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
      GoRoute(
        path: Approutes.settings,
        builder: (context, state) {
          return SettingScreen();
        },
      ),
      GoRoute(
        path: Approutes.signup,
        builder: (context, state) {
          return SignupScreen();
        },
      ),
      GoRoute(
        path: Approutes.forgotPassword,
        builder: (context, state) {
          return ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: Approutes.croprecommendation,
        builder: ((context, state) {
          return CropRecommendationScreen();
        }),
      ),
      GoRoute(
        path: Approutes.district,
        builder: ((context, state) {
          return DistrictSelectionScreen();
        }),
      ),
    ],
  );
}