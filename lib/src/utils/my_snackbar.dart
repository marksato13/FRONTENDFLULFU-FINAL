import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/my_colors.dart';

class MySnackbar {
  static void show(BuildContext context, String text, Color backgroundColor) {
    if (context == null) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, MyColors.successColor);
  }

  static void showErrorAcceso(BuildContext context, String message) {
    show(context, message, MyColors.errorColor);
  }

  static void showErrorValidacionCampos(BuildContext context, String message) {
    show(context, message, MyColors.validationColor);
  }

  static void showProblemasServidor(BuildContext context, String message) {
    show(context, message, MyColors.serverErrorColor);
  }

}
