import 'package:flutter/material.dart';
import 'package:shop_wise/app/view/dialog/dialog_format.dart';

abstract class DialogFunctions {
  factory DialogFunctions() {
    return DialogFormat();
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration,
  });
}