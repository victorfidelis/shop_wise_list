import 'package:shop_wise/app/models/product/product_model.dart';

class ProductListModel {
  ProductListModel({
    this.id,
    required this.product,
    this.price = 0,
    this.quantity = 0,
    this.total = 0,
    this.check = false,
  });

  final int? id;
  final ProductModel product;
  final double price;
  final double quantity;
  final double total;
  final bool check;

  ProductListModel copyWith({
    int? id,
    ProductModel? product,
    double? price,
    double? quantity,
    double? total,
    bool? check,
  }) {
    return ProductListModel(
      id: id ?? this.id,
      product: product ?? this.product,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      check: check ?? this.check,
    );
  }

  bool isEquals(ProductListModel productList) {
    return id == productList.id && product.isEquals(productList.product);
  }
}
