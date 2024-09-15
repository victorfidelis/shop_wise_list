import 'package:intl/intl.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';

final NumberFormat quantityFormat = NumberFormat("###,###,##0.###", 'pt_BR');
final NumberFormat priceFormat = NumberFormat("###,###,##0.00", 'pt_BR');

enum ProductListStatus { initial, loading, success, failure }

class ProductListState {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.list = const ListModel(),
    this.items = const [],
    this.filteredItems = const [],
    this.isFilter = false,
    this.productsTips = const [],
    this.product = const ProductModel(),
    this.nameError = '',
    this.deletedProductList,
    this.categoriesTips = const [],
    this.categories = const [],
    this.filteredCategories = const [],
  });

  final ProductListStatus status;
  final ListModel list;
  final List<ProductListModel> items;
  final List<ProductListModel> filteredItems;
  final ProductListModel? deletedProductList;
  final bool isFilter;
  final List<ProductModel> productsTips;
  final ProductModel product;
  final String nameError;
  final List<CategoryModel> categoriesTips;
  final List<CategoryListModel> categories;
  final List<CategoryListModel> filteredCategories;

  double get totalShop {
    if (items.isEmpty) return 0;
    return items.map((e) => e.total).reduce((value, element) => value + element);
  }

  int get quantityShop {
    return items.length;
  }

  ProductListState copyWith({
    ProductListStatus? status,
    ListModel? list,
    List<ProductListModel>? items,
    List<ProductListModel>? filteredItems,
    bool? isFilter,
    List<ProductModel>? productsTips,
    ProductModel? product,
    String? nameError,
    ProductListModel? deletedProductList,
    List<CategoryModel>? categoriesTips,
    List<CategoryListModel>? categories,
    List<CategoryListModel>? filteredCategories,
  }) {
    return ProductListState(
      status: status ?? this.status,
      list: list ?? this.list,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      isFilter: isFilter ?? this.isFilter,
      productsTips: productsTips ?? this.productsTips,
      product: product ?? this.product,
      nameError: nameError ?? this.nameError,
      deletedProductList: deletedProductList,
      categoriesTips: categoriesTips ?? this.categoriesTips,
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
    );
  }
}
