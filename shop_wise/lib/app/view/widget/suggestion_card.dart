import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.hasDivider,
  });

  final String suggestion;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(14),
                child: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        hasDivider ? Divider(height: 4) : SizedBox(),
      ],
    );
  }
}
