import 'package:shop_wise/app/models/category/category_model.dart';

enum CategoryStatus { initial, loading, success, failure }

final class CategoryState {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const <CategoryModel>[],
    this.deletedCategory,
    this.filteredCategories = const [],
    this.isFilter = false,
    this.deletedCategoryVerify,
    this.deletePermission = false,
  });

  final CategoryStatus status;
  final List<CategoryModel> categories;
  final CategoryModel? deletedCategory;
  final List<CategoryModel> filteredCategories;
  final bool isFilter;
  final CategoryModel? deletedCategoryVerify;
  final bool deletePermission;

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryModel>? categories,
    CategoryModel? deletedCategory,
    List<CategoryModel>? filteredCategories,
    bool? isFilter,
    CategoryModel? deletedCategoryVerify,
    bool? deletePermission,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      deletedCategory: deletedCategory,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      isFilter: isFilter ?? this.isFilter,
      deletedCategoryVerify: deletedCategoryVerify,
      deletePermission: deletePermission ?? this.deletePermission,
    );
  }
}
