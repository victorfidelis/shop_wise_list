import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository_sqflite.dart';

abstract class CategoryRepository {
  factory CategoryRepository() {
    return CategoryRepositorySqflite();
  }

  void dispose();
  Future<List<CategoryModel>> getAll();
  Future<List<CategoryModel>> getLike(String name);
  Future<CategoryModel?> get(String name);
  Future<void> update(CategoryModel categoryModel);
  Future<CategoryModel> insert(CategoryModel categoryModel);
  Future<void> delete(CategoryModel categoryModel);
  Future<bool> categoryInProduct(CategoryModel categoryModel);
}