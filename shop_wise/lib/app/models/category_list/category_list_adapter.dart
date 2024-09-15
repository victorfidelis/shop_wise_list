import 'package:shop_wise/app/models/category/category_adapter.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';

class CategoryListAdapter {
  static CategoryListModel fromRepository(Map categoryListMap) {

    return CategoryListModel(
      category: CategoryModel(
        id: categoryListMap['categoryId'],
        name: categoryListMap['categoryName'],
      ),
      price: categoryListMap['price'],
      quantity: categoryListMap['quantity'],
      total: categoryListMap['total'],
      dataVisible: categoryListMap['dataVisible'] == 1,
    );
  }

  static Map toMap(CategoryListModel categoryList) {
    return {
      'category': CategoryAdapter.toMap(categoryList.category),
      'price': categoryList.price,
      'quantity': categoryList.quantity,
      'total': categoryList.total,
      'dataVisible': categoryList.dataVisible,
    };
  }

  static CategoryListModel fromMap(Map categoryListMap) {
    
    return CategoryListModel(
      category: CategoryAdapter.fromMap(categoryListMap['category']),
      price: categoryListMap['price'],
      quantity: categoryListMap['quantity'],
      total: categoryListMap['total'],
      dataVisible: categoryListMap['dataVisible'],
    );
  }
}
