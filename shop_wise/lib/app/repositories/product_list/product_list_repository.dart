

import 'package:shop_wise/app/models/history/history_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository_sqflite.dart';

abstract class ProductListRepository {
  factory ProductListRepository() {
    return ProductListRepositorySqflite();
  }

  void dispose();
  Future<List<ProductListModel>> getAll(ListModel list);
  Future<void> update(ProductListModel productListModel);
  Future<ProductListModel> insert(ListModel list, ProductListModel productListModel);
  Future<void> delete(ProductListModel productListModel);
  Future<List<HistoryModel>> getHistory(ProductModel product);
}