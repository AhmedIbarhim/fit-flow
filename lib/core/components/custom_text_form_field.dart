import 'package:fit_flow/core/utils/app_colors.dart';
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
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        labelText: label,
        labelStyle: AppTextStyles.regular11,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
    );
  }

  OutlineInputBorder _buildBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }
}

class CustomPassWordField extends StatefulWidget {
  const CustomPassWordField({super.key, this.controller, this.onSaved});

  final TextEditingController? controller;
  final void Function(String?)? onSaved;

  @override
  State<CustomPassWordField> createState() => _CustomPassWordFieldState();
}

class _CustomPassWordFieldState extends State<CustomPassWordField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      onSaved: widget.onSaved,
      label: 'Password',
      obscureText: _obscure,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          color: AppColors.primaryColor,
        ),
        onPressed: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
      ),
    );
  }
}
