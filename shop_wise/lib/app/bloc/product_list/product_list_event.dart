import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';

enum ProductListOrder{check, product, quantity, price, total}

sealed class ProductListEvent {
  const ProductListEvent();
}

class ProductListStarted extends ProductListEvent {
  const ProductListStarted({required this.list});

  final ListModel list;
}

class ProductListInserted extends ProductListEvent {
  const ProductListInserted({
    required this.productList,
  });

  final ProductListModel productList;
}

class ProductListUpdated extends ProductListEvent {
  const ProductListUpdated({required this.productList});

  final ProductListModel productList;
}

class ProductSearched extends ProductListEvent {
  const ProductSearched({required this.text});

  final String text;
}

class ProductTipSelected extends ProductListEvent {
  const ProductTipSelected({required this.product});

  final ProductModel product;
}

final class NameValidated extends ProductListEvent {
  const NameValidated({required this.nameError});

  final String nameError;
}

final class NewItem extends ProductListEvent {
  const NewItem();
}

final class ItemChanged extends ProductListEvent {
  const ItemChanged({required this.productList});

  final ProductListModel productList;
}

final class ItemDeleted extends ProductListEvent {
  const ItemDeleted({required this.productList});

  final ProductListModel productList;
}

final class SetFilter extends ProductListEvent {
  const SetFilter({required this.filter});

  final String filter;
}

final class SetOrder extends ProductListEvent {
  const SetOrder({required this.order});

  final ProductListOrder order;
}

final class ListExported extends ProductListEvent {
  const ListExported();
}

final class ListSharedText extends ProductListEvent {
  const ListSharedText({this.ignoreValues = false});

  final bool ignoreValues;
}

final class CategorySearched extends ProductListEvent {
  const CategorySearched({required this.text});

  final String text;
}

final class CategorySelected extends ProductListEvent {
  const CategorySelected({required this.category});

  final CategoryModel category;
}

final class CategoryInsertedByProductList extends ProductListEvent {
  const CategoryInsertedByProductList({ required this.category});

  final CategoryModel category;
}

final class CategoryChanged extends ProductListEvent {
  const CategoryChanged({required this.categoryList});

  final CategoryListModel categoryList;
}

final class EncapsulateCategory extends ProductListEvent {
  const EncapsulateCategory();
}

final class ExpandCategory extends ProductListEvent {
  const ExpandCategory();
}