import 'package:fasalguru/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    await Future.delayed(const Duration(seconds: 4));
    context.go(Approutes.onboarding);
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
}
