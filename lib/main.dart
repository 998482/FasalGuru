import 'package:fasalguru/firebase_options.dart';
import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/local/irrigation_local.dart';
import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/local/weather_database.dart';
import 'package:fasalguru/repository/irrigation/irrigation_repository.dart';
import 'package:fasalguru/services/weather/dio_client.dart';
import 'package:fasalguru/viewModel/AuthenticationViewModel/authViewModel.dart';
import 'package:fasalguru/viewModel/HomeRecommdation/recommendation_viewmodel.dart';
import 'package:fasalguru/viewModel/cropRecommendation/crop_recommendation_viewmodel.dart';
import 'package:fasalguru/viewModel/district/DistrictViewModel.dart';
import 'package:fasalguru/viewModel/irrigation/irrigation_viewmodel.dart';
import 'package:fasalguru/viewModel/locale/LocaleViewModel.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'package:fasalguru/navigation/gorouter.dart';
import 'package:fasalguru/repository/weather/weather_repository.dart';
import 'package:fasalguru/services/weather/weather_api_service.dart';
import 'package:fasalguru/viewModel/LocationViewModel/LocationViewModel.dart';
import 'package:fasalguru/viewModel/cropSelection/CropSelectionViewModel.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';

/// Holds the local-only decision needed to pick the first route.
/// Filled once in main() before runApp(), read by GoRouter's redirect.
///
/// IMPORTANT: extends ChangeNotifier now. GoRouter's `refreshListenable`
/// listens to this object -- jab bhi login / district / onboarding state
/// change ho (e.g. login screen se login success, ya district select hone
/// ke baad), us jagah se `startupState.updateXxx()` call karo. Wo
/// `notifyListeners()` fire karega aur GoRouter apna `redirect` callback
/// dobara FRESH values ke saath re-evaluate karega. Isse "too many
/// redirects" / stuck-on-district-screen wala loop fix hota hai.
class AppStartupState extends ChangeNotifier {
  bool _onboardingDone;
  bool _isLoggedIn;
  bool _hasDistrict;

  AppStartupState({
    required bool onboardingDone,
    required bool isLoggedIn,
    required bool hasDistrict,
  })  : _onboardingDone = onboardingDone,
        _isLoggedIn = isLoggedIn,
        _hasDistrict = hasDistrict;

  bool get onboardingDone => _onboardingDone;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasDistrict => _hasDistrict;

  void setOnboardingDone(bool value) {
    if (_onboardingDone == value) return;
    _onboardingDone = value;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    notifyListeners();
  }

  void setHasDistrict(bool value) {
    if (_hasDistrict == value) return;
    _hasDistrict = value;
    notifyListeners();
  }
}

late final AppStartupState startupState;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep the native splash (from pubspec flutter_native_splash config) on
  // screen until we explicitly remove it below.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ---- Minimum local checks needed to decide the first screen ----
  // No Firestore, no weather, no ML here — just local prefs + cached auth.
  final onboardingDone = await LocationPrefs.isOnboardingDone();
  final currentUser = FirebaseAuth.instance.currentUser;
  final hasDistrict = currentUser == null
      ? false
      : await LocationPrefs.getDistrict() != null;

  startupState = AppStartupState(
    onboardingDone: onboardingDone,
    isLoggedIn: currentUser != null,
    hasDistrict: hasDistrict,
  );

  // ---- Existing DB / repository setup — unchanged ----
  final database = await $FloorAppDatabase.databaseBuilder("fasalguru.db").build();

  final weatherRepository = WeatherRepository(
    WeatherApiService(DioClient.dio),
    database.weatherDao,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final vm = DistrictViewModel();
            vm.loadSavedDistrict();
            return vm;
          },
        ),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel()..loadProfile()),
        ChangeNotifierProvider(create: (_) => RecommendationViewModel()),
        ChangeNotifierProvider(create: (_) => CropSelectionViewModel()),
        ChangeNotifierProvider(create: (_) => CropRecommendationViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LocaleViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel(weatherRepository)),
        ChangeNotifierProvider(
          create: (_) => IrrigationViewModel(
            repository: IrrigationRepository(
              irrigationDao: database.irrigationDao,
              weatherRepository: weatherRepository,
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );

  // First frame is about to render with the correct screen already decided
  // (via GoRouter redirect using startupState) — safe to drop native splash now.
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeViewModel = context.watch<LocaleViewModel>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(startupState),
      title: 'Flutter Demo',
      locale: localeViewModel.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontWeight: FontWeight.w700),
          displaySmall: TextStyle(fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontWeight: FontWeight.w300),
          labelLarge: TextStyle(fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontWeight: FontWeight.w400),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF1D4D38),
          onPrimary: Colors.white,
          secondary: Color(0xFF3E7259),
          onSecondary: Colors.white,
          tertiary: Color(0xFFD3AF54),
          surface: Color(0xFFFAF8E7),
          onSurface: Color(0xFF1F2923),
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8E7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D4D38),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D4D38),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFD1D7D3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFD1D7D3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF1D4D38), width: 1.5),
          ),
        ),
      ),
    );
  }
}