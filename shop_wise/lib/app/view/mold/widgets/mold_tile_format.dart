import 'package:flutter/material.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';

class MoldTileFormat extends StatelessWidget {
  MoldTileFormat({
    super.key,
    required this.mold,
    this.onLongPress,
    this.onTap,
  });

  final MoldModel mold;
  final Function()? onLongPress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String name = mold.name;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: mold.selected ? Border.all(color: Colors.green, width: 4) : null,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 4)
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
