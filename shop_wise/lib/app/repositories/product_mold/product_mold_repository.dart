
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/repositories/product_mold/product_mold_repository_sqflite.dart';

abstract class ProductMoldRepository {
  factory ProductMoldRepository() {
    return ProductMoldRepositorySqflite();
  }

  void dispose();
  Future<List<ProductMoldModel>> getAll(MoldModel moldModel);
  Future<ProductMoldModel> insert(MoldModel mold, ProductMoldModel productMold);
  Future<void> delete(ProductMoldModel productMold);
}
