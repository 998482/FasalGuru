import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/ui/Widgets/customBackButton.dart';
import 'package:fasalguru/ui/bottomNavigation/bottomNavigation.dart';
import 'package:fasalguru/viewModel/LocationViewModel/LocationViewModel.dart';
import 'package:fasalguru/viewModel/cropRecommendation/crop_recommendation_viewmodel.dart';
import 'package:fasalguru/viewModel/district/DistrictViewModel.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Localization ab ON hai. Result model (CropRecommendationResultModel) ke
// Hindi fields (headlineHindi, topCropNameHindi, reasonHindi, etc.) ko
// current app locale (Localizations.localeOf(context)) ke hisaab se switch
// kiya ja raha hai — jab user LocaleViewModel se toggle karega, ye bhi
// automatically switch ho jayega, alag se kuch karne ki zaroorat nahi.

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vm = context.read<CropRecommendationViewModel>();
    final locationVm = context.read<LocationViewModel>();
    final weatherVm = context.read<WeatherViewModel>();
    final districtVm = context.read<DistrictViewModel>();

    await vm.init();

    // Step 0: district DistrictViewModel se lo (jo user ne select kiya tha).
    // Agar kisi wajah se abhi khali hai to saved prefs se load karne ki
    // koshish karo, warna 'Lucknow' fallback.
    if (!districtVm.hasSelection) {
      await districtVm.loadSavedDistrict();
    }
    final district = districtVm.selectedDistrict?.district.name ?? 'Lucknow';

    // Step 1: location fetch (LocationHandler sirf lat/long deta hai)
    await locationVm.fetchLocation();
    final loc = locationVm.location;

    // Step 2: us lat/long se weather load karo (fallback: Lucknow approx coords)
    await weatherVm.loadWeather(
      latitude: loc?.latitude ?? 26.8467,
      longitude: loc?.longitude ?? 80.9462,
    );
    final w = weatherVm.currentWeather;

    // Step 3: recommendation call — CurrentWeatherEntity ke fields
    // CurrentWeatherModel jaise hi hone chahiye (temperature, humidity, rain)
    await vm.fetchRecommendation(
      district: district,
      temperature: w?.temperature ?? 25.0,
      humidity: (w?.humidity ?? 70).toDouble(),
      rainfallMm: w?.rain ?? 100.0,
    );
  }

  IconData _cropIcon(String cropKey) {
    const iconMap = {
      'rice': Icons.grain, 'maize': Icons.eco, 'wheat': Icons.grass,
      'cotton': Icons.filter_vintage, 'coffee': Icons.coffee,
      'coconut': Icons.park, 'banana': Icons.eco, 'mango': Icons.eco,
      'orange': Icons.circle, 'grapes': Icons.bubble_chart,
      'watermelon': Icons.circle, 'muskmelon': Icons.circle,
      'papaya': Icons.eco, 'apple': Icons.eco, 'pomegranate': Icons.circle,
    };
    return iconMap[cropKey] ?? Icons.spa;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isHindi = locale.languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackbutton(
          pressed: () => context.pop(),
        ),
        title: Text(l10n.cropSuggestion),
      ),
      body: Consumer<CropRecommendationViewModel>(
        builder: (context, vm, _) {
          if (vm.state == CropRecommendationState.loading ||
              vm.state == CropRecommendationState.idle) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(l10n.preparingRecommendation),
                ],
              ),
            );
          }

          if (vm.state == CropRecommendationState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error, size: 40),
                    const SizedBox(height: 12),
                    Text(vm.errorMessage ?? l10n.somethingWentWrong, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _load, child: Text(l10n.tryAgain)),
                  ],
                ),
              ),
            );
          }

          final r = vm.result!;

          return RefreshIndicator(
            onRefresh: _load,
            color: colorScheme.primary,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Date + headline
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text(_formattedDate(DateTime.now(), locale),
                        style: TextStyle(color: colorScheme.secondary, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isHindi ? r.headlineHindi : r.headlineEnglish,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 18),

                // Hero card — animated confidence bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: colorScheme.onPrimary.withOpacity(0.15),
                            child: Icon(_cropIcon(r.topCropKey), color: colorScheme.tertiary, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              isHindi ? r.topCropNameHindi : r.topCropNameEnglish,
                              style: TextStyle(color: colorScheme.onPrimary, fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: r.topConfidence / 100),
                                duration: const Duration(milliseconds: 700),
                                builder: (context, value, _) => LinearProgressIndicator(
                                  value: value,
                                  minHeight: 10,
                                  backgroundColor: colorScheme.onPrimary.withOpacity(0.15),
                                  valueColor: AlwaysStoppedAnimation(colorScheme.tertiary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('${r.topConfidence.toStringAsFixed(0)}%',
                              style: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.w700, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isHindi ? r.reasonHindi : r.reasonEnglish,
                        style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.85), fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),

                if (r.usedEstimatedSoilData) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.soilDataEstimatedNote,
                            style: TextStyle(fontSize: 11.5, color: colorScheme.onSurface.withOpacity(0.75)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 26),
                Text(l10n.otherGoodOptions,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                const SizedBox(height: 10),

                ...r.alternates.map((a) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD1D7D3)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: colorScheme.secondary.withOpacity(0.12),
                            child: Icon(_cropIcon(a.key), color: colorScheme.secondary, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(isHindi ? a.nameHindi : a.nameEnglish,
                                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500, fontSize: 15)),
                          ),
                          Text('${a.confidence.toStringAsFixed(0)}%',
                              style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),

                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 18, color: colorScheme.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                           l10n.weatherChangesDailyNote,
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: AppBottomNavBar.cropRoute,
      ),
    );
  }

  // Locale-aware date formatting — month names automatically switch
  // (e.g. "17 Aug 2026" in English, "17 अग॰ 2026" in Hindi) via intl's
  // built-in locale data, jo flutter_localizations already initialize
  // kar deta hai. Koi extra ARB keys ki zaroorat nahi.
  String _formattedDate(DateTime date, Locale locale) {
    return DateFormat('d MMM yyyy', locale.toString()).format(date);
  }
}