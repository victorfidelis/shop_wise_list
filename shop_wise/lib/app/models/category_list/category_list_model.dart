import 'package:shop_wise/app/models/category/category_model.dart';

class CategoryListModel {
  CategoryListModel({
    required this.category,
    this.price = 0,
    this.quantity = 0,
    this.total = 0,
    this.dataVisible = false,
  });

  final CategoryModel category;
  final double price;
  final double quantity;
  final double total;
  final bool dataVisible;

  CategoryListModel copyWith({
    int? id,
    CategoryModel? category,
    double? price,
    double? quantity,
    double? total,
    bool? dataVisible,
  }) {
    return CategoryListModel(
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      dataVisible: dataVisible ?? this.dataVisible,
    );
  }

  bool isEquals(CategoryListModel categoryList) {
    return category.isEquals(categoryList.category);
  }
}
