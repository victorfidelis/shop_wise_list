import 'package:flutter/services.dart';

class DecimalMask extends TextInputFormatter {
  const DecimalMask({this.decimalPlaces = 0});

  final int decimalPlaces;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formatter = newValue.text.replaceAll('.', ',');
    String regEx = '';
    for (int i = 0; i < decimalPlaces; i++) {
      regEx += '[0-9]?';
    }

    if (!RegExp('^([0-9]*([,]?$regEx))?\$').hasMatch(formatter)) return oldValue;

    return newValue.copyWith(text: formatter);
  }
}
