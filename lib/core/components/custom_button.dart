import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.enabled = true,
      this.color = AppColors.primaryColor,
      this.textColor = Colors.white});
  final void Function()? onPressed;
  final String text;
  final bool enabled;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: enabled ? onPressed : null,
      color: color,
      disabledColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textColor: textColor,
      minWidth: double.infinity,
      height: 60,
      child: FittedBox(child: Text(text, style: AppTextStyles.bold16)),
    );
  }
}
