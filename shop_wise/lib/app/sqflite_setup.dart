
import 'package:shop_wise/app/constants/default_categories.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/repositories/category/category_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/store/store_repository_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteSetup {
  final String nameDb = 'list.db';
  final String listTable = 'listTable';
  final String storeTable = 'storeTable';
  final String categoryTable = 'categoryTable';
  final String productTable = 'productTable';
  final String productListTable = 'productListTable';
  final String moldTable = 'moldTable';
  final String productMoldTable = 'productMoldTable';
  Database? mainDatabase;

  Future<Database> getDatabase() async {

    if (mainDatabase != null) return mainDatabase!;

    final String dataBasePath = await getDatabasesPath();
    final String fullNameDb = '$dataBasePath$nameDb';

    mainDatabase = await openDatabase(
      fullNameDb,
      onOpen: setupDatabase,
    );

    return mainDatabase!;
  }

  Future<void> setupDatabase (Database database) async {
    await _createTables(database);
    await _addNewColumns(database);
  }

  Future<void> _createTables(Database database) async {
    int? listTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [listTable],
      ),
    );
    if (listTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $listTable ('
            'id INTEGER PRIMARY KEY, '
            'storeId INTEGER, '
            'value REAL, '
            'date INT)',
      );
    }

    int? storeTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [storeTable],
      ),
    );
    if (storeTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $storeTable ('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'nameWithoutDiacritic TEXT '
            ')',
      );
    }

    int? categoryTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [categoryTable],
      ),
    );
    if (categoryTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $categoryTable ('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'nameWithoutDiacritic TEXT '
            ')',
      );
      await _insertDefaultCategories(database);
    }

    int? productTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [productTable],
      ),
    );
    if (productTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $productTable ('
            'id INTEGER PRIMARY KEY, '
            'categoryId INTEGER, '
            'name TEXT, '
            'nameWithoutDiacritic TEXT '
            ')',
      );
    }

    int? productListInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [productListTable],
      ),
    );
    if (productListInDb == 0) {
      await database.execute(
        'CREATE TABLE $productListTable ('
            'id INTEGER PRIMARY KEY, '
            'listId INTEGER, '
            'productId INTEGER, '
            'quantity REAL, '
            'price REAL, '
            'total REAL, '
            'check_ INTEGER'
            ')',
      );
    }

    int? moldTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [moldTable],
      ),
    );
    if (moldTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $moldTable ('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'nameWithoutDiacritic TEXT'
            ')',
      );
    }

    int? productMoldTableInDb = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [productMoldTable],
      ),
    );
    if (productMoldTableInDb == 0) {
      await database.execute(
        'CREATE TABLE $productMoldTable ('
            'id INTEGER PRIMARY KEY, '
            'moldId INTEGER, '
            'productId INTEGER'
            ')',
      );
    }
  }

  Future<void> _addNewColumns(Database database) async {

    int? productNameWithoutDiacritic = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        [productTable, '%nameWithoutDiacritic%'],
      ),
    );

    if (productNameWithoutDiacritic != 1) {
      ProductRepositorySqflite productRepository = ProductRepositorySqflite(database: database);
      await database.execute('ALTER TABLE $productTable ADD COLUMN nameWithoutDiacritic TEXT');
      await productRepository.replaceAllDiacritics();
    }

    int? storeNameWithoutDiacritic = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        [storeTable, '%nameWithoutDiacritic%'],
      ),
    );

    if (storeNameWithoutDiacritic != 1) {
      StoreRepositorySqflite storeRepository = StoreRepositorySqflite(database: database);
      await database.execute('ALTER TABLE $storeTable ADD COLUMN nameWithoutDiacritic TEXT');
      await storeRepository.replaceAllDiacritics();
    }

    int? moldNameWithoutDiacritic = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        [moldTable, '%nameWithoutDiacritic%'],
      ),
    );

    if (moldNameWithoutDiacritic != 1) {
      MoldRepositorySqflite moldRepository = MoldRepositorySqflite(database: database);
      await database.execute('ALTER TABLE $moldTable ADD COLUMN nameWithoutDiacritic TEXT');
      await moldRepository.replaceAllDiacritics();
    }

    int? productCategoryId = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        [productTable, '%categoryId%'],
      ),
    );

    if (productCategoryId != 1) {
      ProductRepositorySqflite productRepository = ProductRepositorySqflite(database: database);
      await database.execute('ALTER TABLE $productTable ADD COLUMN categoryId INTEGER');
      await productRepository.replaceAllDiacritics();
    }
  }

  Future<void> _insertDefaultCategories(Database database) async {
    CategoryRepository categoryRepository =  CategoryRepositorySqflite(database: database);
    for (CategoryModel category in DefaultCategories.categories) {
      await categoryRepository.insert(category);
    }
  }
}
