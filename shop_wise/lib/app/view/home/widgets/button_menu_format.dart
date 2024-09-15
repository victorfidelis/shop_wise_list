import 'package:flutter/material.dart';

class ButtonMenuFormat extends StatelessWidget {
  const ButtonMenuFormat({
    super.key,
    required this.onPressed,
    required this.icon,
    this.text,
    this.isCurrent = false,
  });

  final Function() onPressed;
  final IconData icon;
  final String? text;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? Theme.of(context).colorScheme.onSecondary : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        padding: EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isCurrent ? 32 : 24,
              color: Theme.of(context).colorScheme.background,
            ),
            text == null
                ? Container()
                : Text(
                    text!,
              style: TextStyle(
                fontSize: isCurrent ? 12 : 10,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.background,
              ),
                  ),
          ],
        ),
      ),
    );
  }
}
