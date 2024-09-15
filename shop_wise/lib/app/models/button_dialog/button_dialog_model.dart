import 'package:flutter/material.dart';

class ButtonDialogModel {
  const ButtonDialogModel({
    required this.text,
    required this.onPressed,
    this.icon,
    required this.backgroundColor,
  });

  final String text;
  final Function() onPressed;
  final IconData? icon;
  final Color backgroundColor;
}
