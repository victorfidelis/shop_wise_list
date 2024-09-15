import 'package:shop_wise/app/models/product/product_model.dart';

class ProductMoldModel {
  ProductMoldModel({
    this.id,
    required this.product,
  });

  final int? id;
  final ProductModel product;

  ProductMoldModel copyWith({
    int? id,
    ProductModel? product,
  }) {
    return ProductMoldModel(
      id: id ?? this.id,
      product: product ?? this.product,
    );
  }

  bool isEquals(ProductMoldModel productMold) {
    return id == productMold.id && product.isEquals(productMold.product);
  }
}
