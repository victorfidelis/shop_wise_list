
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';

class ProductMoldAdapter {
  static ProductMoldModel fromRepository(Map productMoldMap) {
    return ProductMoldModel(
      id: productMoldMap['id'],
      product: ProductModel(
        id: productMoldMap['productId'],
        name: productMoldMap['productName'],
      ),
    );
  }
}


