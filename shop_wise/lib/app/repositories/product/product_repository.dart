import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';

abstract class ProductRepository {
  factory ProductRepository() {
    return ProductRepositorySqflite();
  }

  void dispose();
  Future<List<ProductModel>> getAll();
  Future<List<ProductModel>> getLike(String name);
  Future<ProductModel?> get(String name);
  Future<void> update(ProductModel productModel);
  Future<ProductModel> insert(ProductModel productModel);
  Future<void> delete(ProductModel productModel);
  Future<bool> productInList(ProductModel productModel);
}