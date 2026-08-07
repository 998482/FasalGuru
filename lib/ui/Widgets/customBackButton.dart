import 'package:flutter/material.dart';

class CustomBackbutton extends StatelessWidget {
  final VoidCallback pressed;

  CustomBackbutton({super.key, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pressed,
      icon: Image.asset("assets/images/backButton.png",
      width: 22,
      height: 25,),
    );
  }
}
