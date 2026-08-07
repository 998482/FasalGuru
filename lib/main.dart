import 'package:fasalguru/local/irrigation_local.dart';
import 'package:fasalguru/local/weather_database.dart';
import 'package:fasalguru/repository/irrigation/irrigation_repository.dart';
import 'package:fasalguru/services/weather/dio_client.dart';
import 'package:fasalguru/viewModel/HomeRecommdation/recommendation_viewmodel.dart';
import 'package:fasalguru/viewModel/irrigation/irrigation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fasalguru/navigation/gorouter.dart';
import 'package:fasalguru/repository/weather/weather_repository.dart';
import 'package:fasalguru/services/weather/weather_api_service.dart';
import 'package:fasalguru/viewModel/LocationViewModel/LocationViewModel.dart';
import 'package:fasalguru/viewModel/cropSelection/CropSelectionViewModel.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder("fasalguru.db")
      .build();

 final weatherRepository = WeatherRepository(
  WeatherApiService(DioClient.dio),
  database.weatherDao,
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationViewModel(),
        ),
        ChangeNotifierProvider(
  create: (_) => RecommendationViewModel(),
),
        ChangeNotifierProvider(
          create: (_) => CropSelectionViewModel(),
        ),
          ChangeNotifierProvider(
          create: (_) => WeatherViewModel(weatherRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => IrrigationViewModel(
            repository: IrrigationRepository(irrigationDao: database.irrigationDao, weatherRepository: weatherRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes,
      title: 'Flutter Demo',
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

        // Color Scheme Configuration
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF1D4D38),      // Deep Forest Green (Main Buttons/App Bar)
          onPrimary: Colors.white,         // Color on Primary (Text on Green)
          secondary: Color(0xFF3E7259),    // Sage Green
          onSecondary: Colors.white,
          tertiary: Color(0xFFD3AF54),     // Sun-bleached Gold
          surface: Color(0xFFFAF8E7),      // App background surface
          onSurface: Color(0xFF1F2923),    // Primary text color
          error: Colors.redAccent,
          onError: Colors.white,
        ),

        // Scaffold Background Color
        scaffoldBackgroundColor: const Color(0xFFFAF8E7),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D4D38),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        // Elevated Button Theme (Primary Buttons)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D4D38), // Green BG
            foregroundColor: Colors.white,             // Text Color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),

        // Input Decoration (TextField Styling)
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
