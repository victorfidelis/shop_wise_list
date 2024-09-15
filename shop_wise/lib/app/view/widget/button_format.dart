import 'package:flutter/material.dart';

class ButtonFormat extends StatelessWidget {
  const ButtonFormat({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  final Function() onPressed;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon == null
                ? SizedBox(height: 0, width: 0)
                : Icon(
                    icon,
                    color: Theme.of(context).colorScheme.background,
                  ),
            icon == null ? SizedBox(height: 0, width: 0) : SizedBox(width: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
