import 'package:flutter/material.dart';
import 'package:shop_wise/app/models/category/category_model.dart';

class CategoryTileFormat extends StatelessWidget {
  CategoryTileFormat({
    super.key,
    required this.category,
    this.onLongPress,
    this.onTap,
  });

  final CategoryModel category;
  final Function()? onLongPress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String name = category.name;

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
