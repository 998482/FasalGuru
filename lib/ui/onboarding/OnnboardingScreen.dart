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

  Future<void> _skip() async {
    await LocationPrefs.setOnboardingDone();
    startupState.setOnboardingDone(true);
    if (!mounted) return;
    context.go(Approutes.login);
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
    final screenHeight = MediaQuery.of(context).size.height;

    // Available height ke hisaab se onboarding area ka height decide karo,
    // taaki chhote/bade screen aur alag-alag language text length dono
    // ke saath overflow na ho.
    final pageAreaHeight = (screenHeight * 0.45).clamp(280.0, 400.0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: pageAreaHeight,
              child: PageView(
                controller: controller,
                children: _onboardingData(l10n).map((data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ---- Image: flexible space, kabhi overflow nahi hoga
                      Flexible(
                        flex: 3,
                        child: Transform.translate(
                          offset: const Offset(0, -15),
                          child: Image.asset(
                            data["image"]!,
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // ---- Title: FittedBox se auto-shrink hoga agar
                      // Hindi text lamba ho jaaye, kabhi bhi pixel overflow
                      // nahi dikhega.
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              data["title"]!,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
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
            // Bottom padding taaki floatingActionButton content ko cover na kare
            const SizedBox(height: 90),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ---- Skip button: Flexible taaki lambi Hindi wording bhi
            // Custom_Button ke upar overflow na kare
            Flexible(
              child: TextButton(
                onPressed: _skip,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.skip,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
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