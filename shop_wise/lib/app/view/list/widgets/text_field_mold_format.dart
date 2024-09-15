import 'package:flutter/material.dart';

class TextFieldMoldFormat extends StatelessWidget {
  const TextFieldMoldFormat({
    super.key,
    required this.onTap,
    required this.controller,
    required this.selected,
  });

  final Function() onTap;
  final TextEditingController controller;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      readOnly: true,
      controller: controller,
      style: TextStyle(
        fontSize: selected ? 16 : 14,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiaryContainer,
            width: selected ? 2.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiaryContainer,
            width: selected ? 2.5 : 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiaryContainer,
            width: selected ? 2.5 : 1,
          ),
        ),
        label: Text(
          'Modelo',
        ),
      ),
    );
  }
}
