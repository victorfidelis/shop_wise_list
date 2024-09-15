import 'package:shop_wise/app/models/history/history_adapter.dart';
import 'package:shop_wise/app/models/history/history_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_adapter.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class ProductListRepositorySqflite implements ProductListRepository {
  Database? database;
  String productListTable = '';
  String productTable = '';
  String categoryTable = '';
  String listTable = '';
  String storeTable = '';

  ProductListRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (productListTable.isEmpty) {
      productListTable = sqfliteSetup.productListTable;
    }
    if (categoryTable.isEmpty) {
      categoryTable = sqfliteSetup.categoryTable;
    }
    if (productTable.isEmpty) {
      productTable = sqfliteSetup.productTable;
    }
    if (listTable.isEmpty) {
      listTable = sqfliteSetup.listTable;
    }
    if (storeTable.isEmpty) {
      storeTable = sqfliteSetup.storeTable;
    }
  }

  @override
  void dispose() {
    if (database != null) {
      database!.close();
    }
  }

  @override
  Future<void> delete(ProductListModel productListModel) async {
    await _initDatabase();

    String deleteText = ''
        'DELETE FROM '
        '$productListTable '
        'WHERE '
        'id = ?';

    List params = [productListModel.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<List<ProductListModel>> getAll(ListModel list) async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'plt.id, '
        'pt.id productId, '
        'pt.name productName, '
        'cat.id categoryId, '
        'cat.name categoryName, '
        'plt.price, '
        'plt.quantity, '
        'plt.total, '
        'plt.check_ '
        'FROM '
        '$productListTable plt '
        'INNER JOIN $productTable pt on plt.productId = pt.id '
        'LEFT JOIN $categoryTable cat on pt.categoryId = cat.id '
        'WHERE '
        'plt.listId = ?';

    List param = [list.id];
    List<Map> productListMap = await database!.rawQuery(selectText, param);

    List<ProductListModel> productsList =
        productListMap.map((map) => ProductListAdapter.fromRepository(map)).toList();

    return productsList;
  }

  @override
  Future<ProductListModel> insert(ListModel list, ProductListModel productListModel,) async {
    await _initDatabase();

    String insert = ''
        'INSERT INTO $productListTable ( '
        'listId, '
        'productId, '
        'price, '
        'quantity, '
        'total, '
        'check_'
        ') '
        'VALUES (?, ?, ?, ?, ?, ?)';

    List params = [
      list.id,
      productListModel.product.id,
      productListModel.price,
      productListModel.quantity,
      productListModel.total,
      productListModel.check ? 1 : 0,
    ];
    await database!.rawInsert(insert, params);

    ProductListModel productListInserted = (await getLastProductList())!;

    return productListInserted;
  }

  @override
  Future<void> update(ProductListModel productListModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $productListTable '
        'SET '
        'productId = ?, '
        'price = ?, '
        'quantity = ?, '
        'total = ?, '
        'check_ = ? '
        'WHERE '
        'id = ?';

    List params = [
      productListModel.product.id,
      productListModel.price,
      productListModel.quantity,
      productListModel.total,
      productListModel.check ? 1 : 0,
      productListModel.id,
    ];
    await database!.rawUpdate(updateText, params);
  }

  Future<ProductListModel?> getLastProductList() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'plt.id, '
        'pt.id productId, '
        'pt.name productName, '
        'cat.id categoryId, '
        'cat.name categoryName, '
        'plt.price, '
        'plt.quantity, '
        'plt.total, '
        'plt.check_ '
        'FROM '
        '$productListTable plt '
        'INNER JOIN $productTable pt on plt.productId = pt.id '
        'LEFT JOIN $categoryTable cat on pt.categoryId = cat.id '
        'ORDER BY plt.id DESC '
        'LIMIT 1';

    List<Map> productsMap = await database!.rawQuery(selectText);

    if (productsMap.isEmpty) return null;

    ProductListModel product = ProductListAdapter.fromRepository(productsMap[0]);

    return product;
  }

  @override
  Future<List<HistoryModel>> getHistory(ProductModel product) async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'plt.id, '
        'st.id storeId, '
        'st.name storeName, '
        'pt.id productId, '
        'pt.name productName, '
        'cat.id categoryId, '
        'cat.name categoryName, '
        'plt.price, '
        'plt.quantity, '
        'plt.total, '
        'plt.check_, '
        'lt.date '
        'FROM '
        '$listTable lt '
        'INNER JOIN $storeTable st on lt.storeId = st.id '
        'INNER JOIN $productListTable plt on lt.id = plt.listId '
        'INNER JOIN $productTable pt on plt.productId = pt.id '
        'LEFT JOIN $categoryTable cat on pt.categoryId = cat.id '
        'WHERE '
        'pt.id = ? AND (plt.price > 0 OR plt.total > 0) '
        'AND lt.date > ? '
        'ORDER BY lt.date DESC';

    DateTime dateFilter = DateTime.now().add(Duration(days: -180));

    List param = [
      product.id,
      dateFilter.millisecondsSinceEpoch,
    ];
    List<Map> historyMap = await database!.rawQuery(selectText, param);

    List<HistoryModel> history = historyMap.map((map) => HistoryAdapter.fromRepository(map)).toList();

    return history;
  }
}
