import 'package:shop_wise/app/models/category/category_adapter.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';

class ProductAdapter {
  static ProductModel fromRepository(Map productMap) {
    CategoryModel category;
    if (productMap['categoryId'] == null || productMap['categoryId'] == 0) {
      category = CategoryModel(name: '');
    } else {
      category = CategoryModel(
        id: productMap['categoryId'],
        name: productMap['categoryName'],
      );
    }

    return ProductModel(
      id: productMap['id'],
      category: category,
      name: productMap['name'],
    );
  }

  static Map toMap(ProductModel product) {
    return {
      'id': product.id,
      'categoryId': product.category?.id,
      'categoryName': product.category?.name,
      'name': product.name,
    };
  }

  static ProductModel fromMap(Map productMap) {
    CategoryModel? category;
    if (productMap.containsKey('categoryId') && productMap.containsKey('categoryName')) {
      category = CategoryModel(
        id: productMap['categoryId'],
        name: productMap['categoryName'],
      );
    }

    return ProductModel(
      id: productMap['id'],
      category: category,
      name: productMap['name'],
    );
  }
}
