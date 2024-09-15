import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:shop_wise/app/models/category/category_adapter.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepositorySqflite implements CategoryRepository {
  Database? database;
  String categoryTable = '';
  String productTable = '';

  CategoryRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (categoryTable.isEmpty) {
      categoryTable = sqfliteSetup.categoryTable;
    }
    if (productTable.isEmpty) {
      productTable = sqfliteSetup.productTable;
    }
  }

  @override
  void dispose() {
    if (database != null) {
      database!.close();
    }
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$categoryTable';

    List<Map> categoriesMap = await database!.rawQuery(selectText);

    List<CategoryModel> categories =
        categoriesMap.map((categoryMap) => CategoryAdapter.fromRepository(categoryMap)).toList();

    return categories;
  }

  @override
  Future<List<CategoryModel>> getLike(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "id, name "
        "FROM "
        "$categoryTable "
        "WHERE "
        "UPPER(nameWithoutDiacritic) like '%${nameWithoutDiacritic.trim().toUpperCase()}%' "
        "LIMIT 10";

    List<Map> categoriesMap = await database!.rawQuery(selectText);

    List<CategoryModel> categories =
        categoriesMap.map((categoryMap) => CategoryAdapter.fromRepository(categoryMap)).toList();

    return categories;
  }

  @override
  Future<CategoryModel?> get(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "id, name "
        "FROM "
        "$categoryTable "
        "WHERE "
        "trim(upper(nameWithoutDiacritic)) = ? "
        "ORDER BY id "
        "LIMIT 1";

    List param = [nameWithoutDiacritic.trim().toUpperCase()];
    List<Map> categoriesMap = await database!.rawQuery(selectText, param);

    if (categoriesMap.isEmpty) return null;

    CategoryModel category = CategoryAdapter.fromRepository(categoriesMap[0]);

    return category;
  }

  @override
  Future<void> update(CategoryModel categoryModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $categoryTable '
        'SET '
        'name = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      categoryModel.name.trim(),
      categoryModel.nameWithoutDiacritics.trim(),
      categoryModel.id,
    ];

    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<CategoryModel> insert(CategoryModel categoryModel) async {
    await _initDatabase();

    String insert = 'INSERT INTO $categoryTable (name, nameWithoutDiacritic) VALUES (?, ?)';
    List params = [categoryModel.name.trim(), categoryModel.nameWithoutDiacritics.trim()];
    await database!.rawInsert(insert, params);

    CategoryModel categoryInserted = (await getLastCategory())!;

    return categoryInserted;
  }

  @override
  Future<void> delete(CategoryModel categoryModel) async {
    await _initDatabase();

    String deleteText = ''
        'DELETE FROM '
        '$categoryTable '
        'WHERE '
        'id = ?';

    List params = [categoryModel.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<bool> categoryInProduct(CategoryModel categoryModel) async {
    await _initDatabase();

    String selectText = "SELECT COUNT(*) FROM $productTable WHERE categoryId = ?";

    List params = [categoryModel.id];

    int quantityCategories = Sqflite.firstIntValue(await database!.rawQuery(selectText, params)) ?? 0;

    return quantityCategories > 0;
  }

  Future<CategoryModel?> getLastCategory() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$categoryTable '
        'ORDER BY id DESC '
        'LIMIT 1';

    List<Map> categoriesMap = await database!.rawQuery(selectText);

    if (categoriesMap.isEmpty) return null;

    CategoryModel category = CategoryAdapter.fromRepository(categoriesMap[0]);

    return category;
  }

  Future<void> replaceAllDiacritics() async {
    List<CategoryModel> categories = await getAll();
    for (CategoryModel category in categories) {
      await update(category);
    }
  }
}
