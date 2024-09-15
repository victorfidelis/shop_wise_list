import 'package:flutter/material.dart';

class RegisterCardFormat extends StatelessWidget {
  const RegisterCardFormat({
    super.key,
    required this.icon,
    required this.text,
    required this.image,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final AssetImage image;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.fitWidth, opacity: 0.35),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              size: 34,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
