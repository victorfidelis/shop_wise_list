import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_event.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/view/product_list/widgets/product_list_tile_format.dart';

class CategoryListTile extends StatefulWidget {
  CategoryListModel categoryList;
  final List<ProductListModel> productsLists;
  final Function({required ProductListModel productList}) onTap;
  final Function({required ProductListModel productList}) onLongPress;
  final bool hasDivider;

  CategoryListTile({
    super.key,
    required this.categoryList,
    required this.productsLists,
    required this.onTap,
    required this.onLongPress,
    required this.hasDivider,
  });

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool dataVisible = widget.categoryList.dataVisible;

    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              widget.categoryList = widget.categoryList.copyWith(
                dataVisible: !widget.categoryList.dataVisible,
              );
              context.read<ProductListBloc>().add(
                CategoryChanged(
                  categoryList: widget.categoryList.copyWith(
                    dataVisible: widget.categoryList.dataVisible,
                  ),
                ),
              );
              setState(() {});
            },
            child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        widget.categoryList.category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Icon(
                      dataVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
          dataVisible
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.productsLists
                      .map(
                        (e) => ProductListTileFormat(
                          productList: e,
                          onTap: widget.onTap,
                          onLongPress: widget.onLongPress,
                        ),
                      )
                      .toList(),
                )
              : Container(),
          widget.hasDivider
              ? Divider(
                  color: Color(0xffD8C4B6),
                )
              : Container(),
        ],
      ),
    );
  }
}
