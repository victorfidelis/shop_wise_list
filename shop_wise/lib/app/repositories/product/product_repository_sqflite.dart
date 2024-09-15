import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:shop_wise/app/models/product/product_adapter.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/repositories/product/product_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepositorySqflite implements ProductRepository {
  Database? database;
  String productTable = '';
  String productMoldTable = '';
  String productListTable = '';
  String categoryTable = '';

  ProductRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (productTable.isEmpty) {
      productTable = sqfliteSetup.productTable;
    }
    if (productMoldTable.isEmpty) {
      productMoldTable = sqfliteSetup.productMoldTable;
    }
    if (productListTable.isEmpty) {
      productListTable = sqfliteSetup.productListTable;
    }
    if (categoryTable.isEmpty) {
      categoryTable = sqfliteSetup.categoryTable;
    }
  }

  @override
  void dispose() {
    if (database != null) {
      database!.close();
    }
  }

  @override
  Future<List<ProductModel>> getAll() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'pro.id id, '
        'pro.name name, '
        'cat.id categoryId, '
        'cat.name categoryName '
        'FROM '
        '$productTable pro '
        'LEFT JOIN $categoryTable cat on pro.categoryId = cat.id';

    List<Map> productsMap = await database!.rawQuery(selectText);

    List<ProductModel> products =
        productsMap.map((productMap) => ProductAdapter.fromRepository(productMap)).toList();

    return products;
  }

  @override
  Future<List<ProductModel>> getLike(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "pro.id, "
        "pro.name, "
        "cat.id categoryId, "
        "cat.name categoryName "
        "FROM "
        "$productTable pro "
        "LEFT JOIN $categoryTable cat on pro.categoryId = cat.id "
        "WHERE "
        "UPPER(pro.nameWithoutDiacritic) like '%${nameWithoutDiacritic.trim().toUpperCase()}%' "
        "LIMIT 10";

    List<Map> productsMap = await database!.rawQuery(selectText);

    List<ProductModel> products =
        productsMap.map((productMap) => ProductAdapter.fromRepository(productMap)).toList();

    return products;
  }

  @override
  Future<ProductModel?> get(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "pro.id, "
        "pro.name, "
        "cat.id categoryId, "
        "cat.name categoryName "
        "FROM "
        "$productTable pro "
        "LEFT JOIN $categoryTable cat on pro.categoryId = cat.id "
        "WHERE "
        "trim(upper(pro.nameWithoutDiacritic)) = ? "
        "ORDER BY pro.id "
        "LIMIT 1";

    List param = [nameWithoutDiacritic.trim().toUpperCase()];
    List<Map> productsMap = await database!.rawQuery(selectText, param);

    if (productsMap.isEmpty) return null;

    ProductModel product = ProductAdapter.fromRepository(productsMap[0]);

    return product;
  }

  @override
  Future<void> update(ProductModel productModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $productTable '
        'SET '
        'name = ?, '
        'nameWithoutDiacritic = ?, '
        'categoryId = ? '
        'WHERE '
        'id = ?';

    List params = [
      productModel.name.trim(),
      productModel.nameWithoutDiacritics.trim(),
      productModel.category?.id,
      productModel.id,
    ];

    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<ProductModel> insert(ProductModel productModel) async {
    await _initDatabase();

    String insert = ''
        'INSERT INTO $productTable '
        '(name, nameWithoutDiacritic, categoryId) '
        'VALUES (?, ?, ?)';
    List params = [
      productModel.name.trim(),
      productModel.nameWithoutDiacritics.trim(),
      productModel.category?.id,
    ];
    await database!.rawInsert(insert, params);

    ProductModel productInserted = (await getLastProduct())!;

    return productInserted;
  }

  @override
  Future<void> delete(ProductModel productModel) async {
    await _initDatabase();

    String deleteTextMold = ''
        'DELETE FROM '
        '$productMoldTable '
        'WHERE '
        'productId = ?';

    List paramsMold = [productModel.id];

    await database!.rawDelete(deleteTextMold, paramsMold);

    String deleteText = ''
        'DELETE FROM '
        '$productTable '
        'WHERE '
        'id = ?';

    List params = [productModel.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<bool> productInList(ProductModel productModel) async {
    await _initDatabase();

    String selectText = "SELECT COUNT(*) FROM $productListTable WHERE productId = ?";

    List params = [productModel.id];

    int quantityProducts = Sqflite.firstIntValue(await database!.rawQuery(selectText, params)) ?? 0;

    return quantityProducts > 0;
  }

  Future<ProductModel?> getLastProduct() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'pro.id, '
        'pro.name, '
        'cat.id categoryId, '
        'cat.name categoryName '
        'FROM '
        '$productTable pro '
        'LEFT JOIN $categoryTable cat on pro.categoryId = cat.id '
        'ORDER BY pro.id DESC '
        'LIMIT 1';

    List<Map> productsMap = await database!.rawQuery(selectText);

    if (productsMap.isEmpty) return null;

    ProductModel product = ProductAdapter.fromRepository(productsMap[0]);

    return product;
  }

  Future<void> replaceAllDiacritics() async {
    List<ProductModel> products = await getAll();
    for (ProductModel product in products) {
      await update(product);
    }
  }
}
