import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/list/list_adapter.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/repositories/list/list_repository.dart';
import 'package:shop_wise/app/repositories/product/product_repository.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository.dart';
import 'package:shop_wise/app/repositories/store/store_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class ListRepositorySqflite implements ListRepository {
  Database? database;
  String listTable = '';
  String storeTable = '';
  String productListTable = '';
  String productMoldTable = '';

  ListRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (this.database == null) {
      this.database = await sqfliteSetup.getDatabase();
    }
    if (listTable.isEmpty) {
      listTable = sqfliteSetup.listTable;
    }
    if (storeTable.isEmpty) {
      storeTable = sqfliteSetup.storeTable;
    }
    if (productListTable.isEmpty) {
      productListTable = sqfliteSetup.productListTable;
    }
    if (productMoldTable.isEmpty) {
      productMoldTable = sqfliteSetup.productMoldTable;
    }
  }

  @override
  void dispose() {
    if (database != null) {
      database!.close();
    }
  }

  @override
  Future<List<ListModel>> getAll() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'lt.id, '
        'st.id as storeId, '
        'st.name as storeName, '
        '(SELECT ifnull(sum(total), 0.0) total from $productListTable plt where plt.listId = lt.id) as value, '
        'lt.date '
        'FROM '
        '$listTable lt '
        'INNER JOIN $storeTable st on lt.storeId = st.id '
        'ORDER BY date DESC';

    List<Map> listsMap = await database!.rawQuery(selectText);

    List<ListModel> lists = listsMap.map((listMap) => ListAdapter.fromRepository(listMap)).toList();

    return lists;
  }

  @override
  Future<void> delete(ListModel listModel) async {
    await _initDatabase();

    String deleteProductsText = ''
        'DELETE FROM '
        '$productListTable '
        'WHERE '
        'listId = ?';

    List paramsProducts = [listModel.id];
    await database!.rawDelete(deleteProductsText, paramsProducts);

    String deleteText = ''
        'DELETE FROM '
        '$listTable '
        'WHERE '
        'id = ?';

    List params = [listModel.id];
    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<ListModel> insert(ListModel listModel, [MoldModel? mold]) async {
    await _initDatabase();

    if (listModel.date == null) {
      listModel = listModel.copyWith(date: DateTime.now());
    }

    String insert = 'INSERT INTO $listTable (storeId, value, date) VALUES (?, ?, ?)';
    List params = [
      listModel.store.id,
      listModel.value,
      listModel.date!.millisecondsSinceEpoch,
    ];
    await database!.rawInsert(insert, params);

    ListModel listInserted = (await getLastList())!;

    if (mold?.id != null && mold!.id! >= 0) {
      await _insertMold(listInserted, mold);
    }

    return listInserted;
  }

  @override
  Future<void> update(ListModel listModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $listTable '
        'SET '
        'storeId = ? ,'
        'value = ? ,'
        'date = ? '
        'WHERE '
        'id = ?';

    List params = [
      listModel.store.id,
      listModel.value,
      listModel.date?.millisecondsSinceEpoch ?? 0,
      listModel.id,
    ];
    await database!.rawUpdate(updateText, params);
  }

  Future<ListModel?> getLastList() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'lt.id, '
        'st.id as storeId, '
        'st.name as storeName, '
        '(SELECT ifnull(sum(total), 0.0) total from $productListTable plt where plt.listId = lt.id) as value, '
        'lt.date '
        'FROM '
        '$listTable lt '
        'INNER JOIN $storeTable st on lt.storeId = st.id '
        'ORDER BY lt.id DESC '
        'LIMIT 1';

    List<Map> listsMap = await database!.rawQuery(selectText);

    if (listsMap.isEmpty) return null;

    ListModel list = ListAdapter.fromRepository(listsMap[0]);

    return list;
  }

  @override
  Future<ListModel> replicate(ListModel listModel, ListReplicateType listReplicateType) async {
    await _initDatabase();

    ListModel listCloned = listModel.copyWith(date: DateTime.now());
    ListModel list = await insert(listCloned);

    String insertText = ''
        'INSERT INTO $productListTable ( '
        'listId, '
        'productId, '
        'price, '
        'quantity, '
        'total, '
        'check_'
        ') '
        'SELECT '
        '?, '
        'productId, '
        'price, '
        'quantity, '
        'total, '
        'check_ '
        'FROM $productListTable '
        'WHERE listId = ?';

    if (listReplicateType == ListReplicateType.checked) {
      insertText += ' AND check_ = 1';
    } else if (listReplicateType == ListReplicateType.unchecked) {
      insertText += ' AND check_ = 0';
    }

    List params = [
      list.id,
      listCloned.id,
    ];
    await database!.rawInsert(insertText, params);

    ListModel listInserted = (await getLastList())!;

    return listInserted;
  }

  Future<void> _insertMold(ListModel listModel, MoldModel mold) async {
    await _initDatabase();

    String insertText = ''
        'INSERT INTO $productListTable ( '
        'listId, '
        'productId, '
        'price, '
        'quantity, '
        'total, '
        'check_'
        ') '
        'SELECT '
        '?, '
        'productId, '
        '0, '
        '0, '
        '0, '
        '0 '
        'FROM $productMoldTable '
        'WHERE moldId = ?';

    List params = [
      listModel.id,
      mold.id,
    ];
    await database!.rawInsert(insertText, params);
  }

  @override
  Future<ListModel> import(ListModel listModel, List<ProductListModel> items) async {
    await _initDatabase();

    StoreRepository storeRepository = StoreRepository();
    CategoryRepository categoryRepository = CategoryRepository();
    ProductRepository productRepository = ProductRepository();
    ProductListRepository productListRepository = ProductListRepository();

    StoreModel? store = await storeRepository.get(listModel.store.name);
    if (store == null) {
      store = await storeRepository.insert(listModel.store);
    }

    ListModel list = listModel.copyWith(store: store);
    list = await insert(list);

    for (ProductListModel item in items) {
      CategoryModel? category;
      if (item.product.category?.id != null) {
        category = await categoryRepository.get(item.product.category!.name);
        if (category == null) {
          category = await categoryRepository.insert(item.product.category!);
        }
      }

      ProductModel productItem = item.product.copyWith(category: category);
      ProductModel? product = await productRepository.get(productItem.name);
      if (product == null) {
        product = await productRepository.insert(productItem);
      } else {
        product = product.copyWith(category: productItem.category);
        productRepository.update(product);
      }

      ProductListModel productList = item.copyWith(product: product);
      await productListRepository.insert(list, productList);
    }

    storeRepository.dispose();
    productRepository.dispose();
    productListRepository.dispose();

    return list;
  }
}
