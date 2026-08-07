import 'package:flutter/material.dart';
import 'greeting_widget.dart';
import 'location_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GreetingWidget(),
        SizedBox(height: 6),
        LocationWidget(),
      ],
    );
  }
}