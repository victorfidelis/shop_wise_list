import 'package:flutter/material.dart';
import 'package:shop_wise/app/view/mask/decimal_mask.dart';

class TextFieldQuantity extends StatelessWidget {
  TextFieldQuantity({
    super.key,
    required this.controller,
    required this.decimalPlaces,
    required this.label,
    required this.setCalculate,
    required this.calculate,
    required this.addQuantity,
    this.prefix = '',
  });

  final TextEditingController controller;
  final int decimalPlaces;
  final String label;
  final Function() setCalculate;
  final Function() calculate;
  final Function() addQuantity;
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
        suffix: InkWell(
          onTap: addQuantity,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(Icons.add_circle_rounded, size: 24, color: Color(0xff808080)),
          ),
        ),
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
    if (text.startsWith(',') && text.endsWith(','))
      text = '';
    else if (text.startsWith(','))
      text = '0' + text;
    else if (text.endsWith(',')) text = text.substring(0, text.length - 1);
    controller.text = text;
    calculate();
  }
}
