import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';

enum ProductStatus { initial, loading, success, failure }

final class ProductState {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <ProductModel>[],
    this.deletedProduct,
    this.filteredItems = const [],
    this.isFilter = false,
    this.deletedProductVerify,
    this.deletePermission = false,
    this.categoriesTips = const [],
    this.category = const CategoryModel(name: ''),
    this.nameError = '',
  });

  final ProductStatus status;
  final List<ProductModel> products;
  final ProductModel? deletedProduct;
  final List<ProductModel> filteredItems;
  final bool isFilter;
  final ProductModel? deletedProductVerify;
  final bool deletePermission;
  final List<CategoryModel> categoriesTips;
  final CategoryModel category;
  final String nameError;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    ProductModel? deletedProduct,
    List<ProductModel>? filteredItems,
    bool? isFilter,
    ProductModel? deletedProductVerify,
    bool? deletePermission,
    List<CategoryModel>? categoriesTips,
    CategoryModel? category,
    String? nameError,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      deletedProduct: deletedProduct,
      filteredItems: filteredItems ?? this.filteredItems,
      isFilter: isFilter ?? this.isFilter,
      deletedProductVerify: deletedProductVerify,
      deletePermission: deletePermission ?? this.deletePermission,
      categoriesTips: categoriesTips ?? this.categoriesTips,
      category: category ?? this.category,
      nameError: nameError ?? this.nameError,
    );
  }
}
