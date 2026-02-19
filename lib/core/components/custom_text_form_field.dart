import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.onSaved,
  });

  final String label;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        labelText: label,
        labelStyle: AppTextStyles.regular11,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
    );
  }

  OutlineInputBorder buildBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }
}
