import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

import '../components/custom_snackbar.dart';

extension Contextextention on BuildContext {
  Future<T?> showSnackBar<T>({
    required String message,
    SnackBarStates state = SnackBarStates.idle,
    FlashPosition position = FlashPosition.top,
    Duration? duration,
    Widget? action,
    Function(FlashController)? controllerBuilder,
  }) => this.showFlash<T>(
    duration: duration ?? const Duration(seconds: 3),
    builder: (_, controller) {
      controllerBuilder?.call(controller);
      return FlashBar(
        padding: EdgeInsets.zero,
        builder: (_, index) => CustomSnackBar(
          message: message,
          state: state,
          actionButton: action,
        ),
        controller: controller,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // side: BorderSide(),
        ),
        elevation: 0,
        position: position,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        clipBehavior: Clip.antiAlias,
        behavior: FlashBehavior.floating,
        content: const SizedBox(),
      );
    },
  );
}
