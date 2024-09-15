import 'package:flutter/material.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';

class DialogFormat implements DialogFunctions {

  @override
  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: undoAction == null && undoLabel == null
            ? null
            : SnackBarAction(
                label: undoLabel ?? '',
                onPressed: undoAction ?? () {},
              ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}
