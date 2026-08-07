import 'package:flutter/material.dart';

class Custom_Button extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  const Custom_Button({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.color,
    this.onPressed,
  });

  @override
  State<Custom_Button> createState() => _Custom_ButtonState();
}

class _Custom_ButtonState extends State<Custom_Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          splashFactory: InkRipple.splashFactory, // Ripple effect
        ),
        child: Center(child: 
        Text(
          widget.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        )
        ),
      ),
    );
  }
}
