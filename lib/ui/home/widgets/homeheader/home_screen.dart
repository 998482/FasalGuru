import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/bottomNavigation/bottomNavigation.dart';
import 'package:fasalguru/ui/home/widgets/RecommdationButton/Button.dart';
import 'package:fasalguru/ui/home/widgets/cropsSelection/crop_dropdown_widget.dart';
import 'package:fasalguru/ui/home/widgets/datePicker/SowingDateWidget.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/fasalGuruAppbar.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/location_widget.dart'; // 👈 add this import
import 'package:fasalguru/ui/home/widgets/soilCard/soil_selection_widget.dart';
import 'package:fasalguru/ui/home/widgets/weatherwidget/weather_forecast_widget.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'fasal_guru_app_bar.dart'; // 👈 your custom AppBar file

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CropModel? selectedCrop;
  SoilType? selectedSoil;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherViewModel>().loadWeather(
        latitude: 26.8393,
        longitude: 80.9231,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const FasalGuruAppBar(), // 👈 added

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HomeHeaderWidget() hata diya — AppBar ye kaam kar raha hai ab

              const SizedBox(height: 10),

              const LocationWidget(), // 👈 sirf location yahan rakha
              const SizedBox(height: 20),

              const WeatherForecastWidget(),
              const SizedBox(height: 28),

              CropDropdownWidget(
                onCropSelected: (crop) {
                  selectedCrop = crop;
                },
              ),
              const SizedBox(height: 28),

              SoilSelectionWidget(
                onSoilSelected: (soil) {
                  selectedSoil = soil;
                },
              ),
              const SizedBox(height: 28),

              SowingDateWidget(
                onDateSelected: (date) {
                  selectedDate = date;
                },
              ),
              const SizedBox(height: 40),

              RecommendationButton(
                onPressed: () {
                  if (selectedCrop == null ||
                      selectedSoil == null ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.selectCropSoilDate,
                        ),
                      ),
                    );
                    return;
                  }

                  context.push(
                    Approutes.recommendation,
                    extra: {
                      "crop": selectedCrop!.name,
                      "soil": selectedSoil!.name,
                      "date": selectedDate!,
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: AppBottomNavBar.homeRoute,
      ),
    );
  }
}