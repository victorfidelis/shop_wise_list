import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_event.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';

class ProductListTileFormat extends StatefulWidget {
  ProductListTileFormat({
    super.key,
    required this.productList,
    required this.onLongPress,
    required this.onTap,
  });

  ProductListModel productList;
  final Function({required ProductListModel productList}) onLongPress;
  final Function({required ProductListModel productList}) onTap;

  @override
  State<ProductListTileFormat> createState() => _ProductListTileFormatState();
}

class _ProductListTileFormatState extends State<ProductListTileFormat> {
  @override
  Widget build(BuildContext context) {
    final NumberFormat quantityFormat = NumberFormat("###,###,##0.###", 'pt_BR');
    final String quantity = quantityFormat.format(widget.productList.quantity);

    final NumberFormat priceFormat = NumberFormat("###,###,##0.00", 'pt_BR');
    final String price = priceFormat.format(widget.productList.price);
    final String total = priceFormat.format(widget.productList.total);

    return GestureDetector(
      onTap: () {
        widget.onTap(productList: widget.productList);
      },
      onLongPress: () {
        widget.onLongPress(productList: widget.productList);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: widget.productList.check
              ? Color(0xffb4ff9a)
              : Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow, blurRadius: 4, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      widget.productList.product.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Qtde: $quantity',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Preço: R\$ $price',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    'Total: R\$ $total',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.productList =
                      widget.productList.copyWith(check: !widget.productList.check);
                });
                context.read<ProductListBloc>().add(ItemChanged(productList: widget.productList));
              },
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  widget.productList.check ? Icons.check_circle : Icons.circle_outlined,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
