
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';

sealed class ProductMoldEvent {
  const ProductMoldEvent();
}

class ProductMoldStarted extends ProductMoldEvent {
  const ProductMoldStarted({required this.mold});

  final MoldModel mold;
}

class ProductMoldInserted extends ProductMoldEvent {
  const ProductMoldInserted({
    required this.productMold,
  });

  final ProductMoldModel productMold;
}

class ProductSearched extends ProductMoldEvent {
  const ProductSearched({required this.text});

  final String text;
}

class ProductTipSelected extends ProductMoldEvent {
  const ProductTipSelected({required this.product});

  final ProductModel product;
}

final class NameValidated extends ProductMoldEvent {
  const NameValidated({required this.nameError});

  final String nameError;
}

final class NewItem extends ProductMoldEvent {
  const NewItem();
}

final class ItemDeleted extends ProductMoldEvent {
  const ItemDeleted({required this.productMold});

  final ProductMoldModel productMold;
}

final class SetFilter extends ProductMoldEvent {
  const SetFilter({required this.filter});

  final String filter;
}

final class CategorySearched extends ProductMoldEvent {
  const CategorySearched({required this.text});

  final String text;
}

final class CategorySelected extends ProductMoldEvent {
  const CategorySelected({required this.category});

  final CategoryModel category;
}