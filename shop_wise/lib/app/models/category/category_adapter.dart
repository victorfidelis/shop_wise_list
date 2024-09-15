import 'package:shop_wise/app/models/category/category_model.dart';

class CategoryAdapter {
  static CategoryModel fromRepository(Map categoryMap) {
    return CategoryModel(
      id: categoryMap['id'],
      name: categoryMap['name'],
    );
  }

  static Map toMap(CategoryModel category) {
    return {
      'id': category.id,
      'name': category.name,
    };
  }

  static CategoryModel fromMap(Map categoryMap) {
    return CategoryModel(
      id: categoryMap['id'],
      name: categoryMap['name'],
    );
  }
}
