import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_adapter.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';

class ProductListAdapter {
  static ProductListModel fromRepository(Map productListMap) {

    CategoryModel category;
    if (productListMap['categoryId'] == null || productListMap['categoryId'] == 0) {
      category = CategoryModel(name: '');
    } else {
      category = CategoryModel(
        id: productListMap['categoryId'],
        name: productListMap['categoryName'],
      );
    }

    return ProductListModel(
      id: productListMap['id'],
      product: ProductModel(
        id: productListMap['productId'],
        name: productListMap['productName'],
        category: category,
      ),
      price: productListMap['price'],
      quantity: productListMap['quantity'],
      total: productListMap['total'],
      check: productListMap['check_'] == 1,
    );
  }

  static Map toMap(ProductListModel productList) {
    return {
      'id': productList.id,
      'product': ProductAdapter.toMap(productList.product),
      'price': productList.price,
      'quantity': productList.quantity,
      'total': productList.total,
      'check': productList.check,
    };
  }

  static ProductListModel fromMap(Map productListMap) {
    
    return ProductListModel(
      id: productListMap['id'],
      product: ProductAdapter.fromMap(productListMap['product']),
      price: productListMap['price'],
      quantity: productListMap['quantity'],
      total: productListMap['total'],
      check: productListMap['check'],
    );
  }
}
