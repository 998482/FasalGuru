import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/Widgets/Custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  static const int totalPages = 2;

  List<Map<String, String>> get onboardingData => const [
        {
          "image": "assets/images/OnboardingScreen1.0-removebg-preview.png",
          "title": "Right crop, right time",
        },
        {
          "image": "assets/images/OnboardingScreen6-removebg-preview.png",
          "title": "Right crop, right time",
        },
      ];

  void _handleNext() {
    final currentPage = controller.page?.round() ?? 0;

    if (currentPage == totalPages - 1) {
      // last page -> navigate, don't try to animate further
      context.push(Approutes.location);
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: PageView(
                controller: controller,
                children: onboardingData.map((data) {
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
              onPressed: () => context.push(Approutes.location),
              child: Text(
                "Skip",
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
              text: "Next",
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