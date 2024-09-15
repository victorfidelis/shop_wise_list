import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/store/store_repository_sqflite.dart';

abstract class StoreRepository {
  factory StoreRepository() {
    return StoreRepositorySqflite();
  }

  void dispose();
  Future<List<StoreModel>> getAll();
  Future<List<StoreModel>> getLike(String name);
  Future<StoreModel?> get(String name);
  Future<void> update(StoreModel storeModel);
  Future<StoreModel> insert(StoreModel storeModel);
  Future<void> delete(StoreModel storeModel);
  Future<bool> storeInList(StoreModel storeModel);
}