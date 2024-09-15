import 'package:flutter/material.dart';
import 'package:shop_wise/app/view/mask/decimal_mask.dart';

class TextFieldNumber extends StatelessWidget {
  TextFieldNumber({
    super.key,
    required this.controller,
    required this.decimalPlaces,
    required this.label,
    required this.setCalculate,
    required this.calculate,
    this.prefix = '',
  });

  final TextEditingController controller;
  final int decimalPlaces;
  final String label;
  final Function() setCalculate;
  final Function() calculate;
  final String prefix;
  
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    _focusNode.addListener(_validText);

    return TextField(
      focusNode: _focusNode,
      inputFormatters: [DecimalMask(decimalPlaces: decimalPlaces)],
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        prefix: Text(prefix, style: TextStyle(fontSize: 12)),
      ),
      style: TextStyle(fontSize: 20),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  void _validText() {
    if (_focusNode.hasFocus) {
      setCalculate();
      controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      return;
    }
    String text = controller.text;
    if (text.startsWith(',') && text.endsWith(',')) text = '';
    else if (text.startsWith(',')) text = '0' + text;
    else if (text.endsWith(',')) text = text.substring(0, text.length - 1);
    controller.text = text;
    calculate();
  }
}
