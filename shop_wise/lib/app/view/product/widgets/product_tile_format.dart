import 'package:flutter/material.dart';
import 'package:shop_wise/app/models/product/product_model.dart';

class ProductTileFormat extends StatelessWidget {
  ProductTileFormat({
    super.key,
    required this.product,
    this.onLongPress,
    this.onTap,
  });

  final ProductModel product;
  final Function()? onLongPress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String name = product.name;

    return GestureDetector(
      onTap: onTap,
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
              maxLines: 3,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
