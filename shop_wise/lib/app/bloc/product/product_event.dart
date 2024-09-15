import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';

sealed class ProductEvent {
  const ProductEvent();
}

final class ProductStarted extends ProductEvent {
  const ProductStarted();
}

final class ProductInserted extends ProductEvent {
  const ProductInserted({ required this.product});

  final ProductModel product;
}

final class ProductUpdated extends ProductEvent {
  const ProductUpdated({required this.product});

  final ProductModel product;
}

final class ProductDeleteValidated extends ProductEvent {
  const ProductDeleteValidated({required this.product});

  final ProductModel product;
}

final class ProductDeleted extends ProductEvent {
  const ProductDeleted({required this.product});

  final ProductModel product;
}

final class SetFilterProduct extends ProductEvent {
  const SetFilterProduct({required this.filter});

  final String filter;
}

final class CategorySearched extends ProductEvent {
  const CategorySearched({required this.text});

  final String text;
}

final class CategorySelected extends ProductEvent {
  const CategorySelected({required this.category});

  final CategoryModel category;
}

final class NameValidated extends ProductEvent {
  const NameValidated({required this.nameError});

  final String nameError;
}
