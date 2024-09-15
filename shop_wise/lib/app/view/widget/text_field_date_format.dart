import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFieldDateFormat extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String? errorText;
  final Function(DateTime?)? onSet;
  DateTime? dateValue = DateTime.now();

  TextFieldDateFormat({
    super.key,
    required this.controller,
    this.label,
    this.errorText,
    this.onSet,
  });

  @override
  Widget build(BuildContext context) {

    if (controller.text.isNotEmpty) {
      dateValue = DateFormat('dd/MM/yyyy').parse(controller.text);
    }

    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(label ?? ''),
        suffixIcon: const Icon(Icons.event_note),
        errorText: errorText,
      ),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: dateValue,
          firstDate: DateTime(2018, 1, 1),
          lastDate: DateTime(2050, 12, 31),
        ).then((value) {
          if (onSet != null) onSet!(value);
          if (value != null) {
            dateValue = value;
            controller.text = DateFormat('dd/MM/yyyy').format(value);
          }
        });
      },
    );
  }
}