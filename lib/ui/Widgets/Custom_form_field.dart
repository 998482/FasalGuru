import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Image? prefixicon;
  final IconButton? suffixIcon;
  final Color? color;
  final bool obscuretext;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixicon,
    this.suffixIcon,
    this.color,
    required this.obscuretext,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscuretext,
      maxLines: 1,
      validator: validator,

      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface
        ),

        prefixIcon: prefixicon == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefixicon,
              ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor: color ?? theme.colorScheme.surface,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }
}