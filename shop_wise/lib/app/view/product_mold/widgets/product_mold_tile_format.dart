import 'package:flutter/material.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';

class ProductMoldTileFormat extends StatelessWidget {
  ProductMoldTileFormat({
    super.key,
    required this.productMold,
    this.onLongPress,
  });

  final ProductMoldModel productMold;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    String name = productMold.product.name;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
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
