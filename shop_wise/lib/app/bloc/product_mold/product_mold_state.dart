
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';

enum ProductMoldStatus { initial, loading, success, failure }

class ProductMoldState {
  const ProductMoldState({
    this.status = ProductMoldStatus.initial,
    this.mold = const MoldModel(),
    this.items = const [],
    this.filteredItems = const [],
    this.isFilter = false,
    this.productsTips = const [],
    this.product = const ProductModel(),
    this.nameError = '',
    this.deletedProductMold,
    this.categoriesTips = const [],
    this.category = const CategoryModel(name: ''),
  });

  final ProductMoldStatus status;
  final MoldModel mold;
  final List<ProductMoldModel> items;
  final List<ProductMoldModel> filteredItems;
  final bool isFilter;
  final List<ProductModel> productsTips;
  final ProductModel product;
  final String nameError;
  final ProductMoldModel? deletedProductMold;
  final List<CategoryModel> categoriesTips;
  final CategoryModel category;

  ProductMoldState copyWith({
    ProductMoldStatus? status,
    MoldModel? mold,
    List<ProductMoldModel>? items,
    List<ProductMoldModel>? filteredItems,
    bool? isFilter,
    List<ProductModel>? productsTips,
    ProductModel? product,
    String? nameError,
    ProductMoldModel? deletedProductMold,
    List<CategoryModel>? categoriesTips,
    CategoryModel? category,
  }) {
    return ProductMoldState(
      status: status ?? this.status,
      mold: mold ?? this.mold,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      isFilter: isFilter ?? this.isFilter,
      productsTips: productsTips ?? this.productsTips,
      product: product ?? this.product,
      nameError: nameError ?? this.nameError,
      deletedProductMold: deletedProductMold,
      categoriesTips: categoriesTips ?? this.categoriesTips,
      category: category ?? this.category,
    );
  }
}