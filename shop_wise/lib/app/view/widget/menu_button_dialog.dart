import 'package:flutter/material.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';

class MenuButtonDialog extends StatelessWidget {
  MenuButtonDialog({
    super.key,
    required this.buttons,
    this.backgroundColor,
  });

  final List<ButtonDialogModel> buttons;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (backgroundColor == null) backgroundColor = Theme.of(context).colorScheme.background;
    return Center(
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: buttons.map((e) => ButtonDialog(button: e)).toList(),
        ),
      ),
    );
  }
}

class ButtonDialog extends StatelessWidget {
  const ButtonDialog({super.key, required this.button});

  final ButtonDialogModel button;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: button.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextButton(
        onPressed: button.onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Container(
          child: SizedBox(
            width: 240,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: button.icon == null ? Container() : Icon(
                    button.icon,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                Center(
                  child: Text(
                    button.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
