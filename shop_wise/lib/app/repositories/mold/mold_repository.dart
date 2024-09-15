import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository_sqflite.dart';

abstract class MoldRepository {
  factory MoldRepository() {
    return MoldRepositorySqflite();
  }

  void dispose();
  Future<List<MoldModel>> getAll();
  Future<List<MoldModel>> getLike(String name);
  Future<void> update(MoldModel moldModel);
  Future<MoldModel> insert(MoldModel moldModel);
  Future<void> delete(MoldModel moldModel);
}