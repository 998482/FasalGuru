import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/Widgets/Custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fasalguru/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  static const int totalPages = 2;

  // NOTE: ab const nahi hai kyunki l10n (BuildContext) chahiye title ke liye.
  List<Map<String, String>> _onboardingData(AppLocalizations l10n) => [
        {
          "image": "assets/images/OnboardingScreen1.0-removebg-preview.png",
          "title": l10n.onboardingTitle,
        },
        {
          "image": "assets/images/OnboardingScreen6-removebg-preview.png",
          "title": l10n.onboardingTitle,
        },
      ];

  void _handleNext() async {
    final currentPage = controller.page?.round() ?? 0;

    if (currentPage == totalPages - 1) {
      await LocationPrefs.setOnboardingDone();
      startupState.setOnboardingDone(true); // <-- ADD THIS LINE
      if (!mounted) return;
      context.go(Approutes.login); // push -> go
      return;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: PageView(
                controller: controller,
                children: _onboardingData(l10n).map((data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -15), // image thoda upar
                        child: Image.asset(
                          data["image"]!,
                          width: 300,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data["title"]!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: controller,
              count: totalPages,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: primaryColor,
                dotColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                await LocationPrefs.setOnboardingDone();
                startupState.setOnboardingDone(true); // <-- ADD THIS LINE
                if (!mounted) return;
                context.go(Approutes.login); // push -> go
              },
              child: Text(
                l10n.skip,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Custom_Button(
              height: 60,
              width: 120,
              text: l10n.next,
              color: primaryColor,
              onPressed: _handleNext,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}