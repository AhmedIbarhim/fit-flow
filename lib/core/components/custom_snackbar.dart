import 'package:fit_flow/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../extentions/screen_utils_extention.dart';

enum SnackBarStates { idle, success, error, warning, noInternet }

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.message,
    required this.state,
    this.actionButton,
  });

  final String message;
  final SnackBarStates state;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _generateSnackBarColor(state),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 32.toWidth,
                  height: 32.toWidth,
                  padding: const EdgeInsets.all(6),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: _generateSnackBarIconBGColor(state),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    child: Icon(
                      _generateSnackBarIcons(state),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.toWidth),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.black,
                      fontSize: 12.toFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (actionButton != null) actionButton!,
        ],
      ),
    );
  }

  IconData _generateSnackBarIcons(SnackBarStates states) {
    switch (states) {
      case SnackBarStates.idle:
        return Icons.info_rounded;
      case SnackBarStates.success:
        return Icons.check_circle;
      case SnackBarStates.error:
        return Icons.cancel;
      case SnackBarStates.warning:
        return Icons.warning_rounded;
      case SnackBarStates.noInternet:
        return Icons.wifi_off_rounded;
    }
  }

  Color _generateSnackBarColor(SnackBarStates states) {
    switch (states) {
      case SnackBarStates.idle:
        return AppColors.lightPrimaryColor;
      case SnackBarStates.success:
        return AppColors.lightSuccessColor;
      case SnackBarStates.noInternet:
      case SnackBarStates.error:
        return AppColors.lightErrorColor;
      case SnackBarStates.warning:
        return AppColors.lightWarningColor;
    }
  }

  Color _generateSnackBarIconBGColor(SnackBarStates states) {
    switch (states) {
      case SnackBarStates.idle:
        return AppColors.primaryColor;
      case SnackBarStates.success:
        return AppColors.successColor;
      case SnackBarStates.noInternet:
      case SnackBarStates.error:
        return AppColors.errorColor;
      case SnackBarStates.warning:
        return AppColors.warningColor;
    }
  }
}
