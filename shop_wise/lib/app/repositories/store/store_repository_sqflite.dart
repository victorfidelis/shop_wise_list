import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:shop_wise/app/models/store/store_adapter.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/store/store_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class StoreRepositorySqflite implements StoreRepository {
  Database? database;
  String storeTable = '';
  String listTable = '';

  StoreRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (storeTable.isEmpty) {
      storeTable = sqfliteSetup.storeTable;
    }
    if (listTable.isEmpty) {
      listTable = sqfliteSetup.listTable;
    }
  }

  @override
  void dispose() {
    if (database != null) {
      database!.close();
    }
  }

  @override
  Future<List<StoreModel>> getAll() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$storeTable';

    List<Map> storesMap = await database!.rawQuery(selectText);

    List<StoreModel> stores =
        storesMap.map((storeMap) => StoreAdapter.fromRepository(storeMap)).toList();

    return stores;
  }

  @override
  Future<List<StoreModel>> getLike(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "id, name "
        "FROM "
        "$storeTable "
        "WHERE "
        "UPPER(nameWithoutDiacritic) like '%${nameWithoutDiacritic.trim().toUpperCase()}%' "
        "LIMIT 10";

    List<Map> storesMap = await database!.rawQuery(selectText);

    List<StoreModel> stores =
        storesMap.map((storeMap) => StoreAdapter.fromRepository(storeMap)).toList();

    return stores;
  }

  @override
  Future<StoreModel?> get(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "id, name "
        "FROM "
        "$storeTable "
        "WHERE "
        "trim(upper(nameWithoutDiacritic)) = ? "
        "ORDER BY id "
        "LIMIT 1";

    List param = [nameWithoutDiacritic.trim().toUpperCase()];
    List<Map> storesMap = await database!.rawQuery(selectText, param);

    if (storesMap.isEmpty) return null;

    StoreModel store = StoreAdapter.fromRepository(storesMap[0]);

    return store;
  }

  @override
  Future<void> update(StoreModel storeModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $storeTable '
        'SET '
        'name = ? , '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      storeModel.name.trim(),
      storeModel.nameWithoutDiacritics.trim(),
      storeModel.id,
    ];

    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<StoreModel> insert(StoreModel storeModel) async {
    await _initDatabase();

    String insert = 'INSERT INTO $storeTable (name, nameWithoutDiacritic) VALUES (?, ?)';
    List params = [storeModel.name.trim(), storeModel.nameWithoutDiacritics.trim()];
    await database!.rawInsert(insert, params);

    StoreModel storeInserted = (await getLastStore())!;

    return storeInserted;
  }

  @override
  Future<void> delete(StoreModel storeModel) async {
    await _initDatabase();

    String deleteText = ''
        'DELETE FROM '
        '$storeTable '
        'WHERE '
        'id = ?';

    List params = [storeModel.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<bool> storeInList(StoreModel storeModel) async {
    await _initDatabase();

    String selectText = "SELECT COUNT(*) FROM $listTable WHERE storeId = ?";

    List params = [storeModel.id];

    int quantityStores = Sqflite.firstIntValue(await database!.rawQuery(selectText, params)) ?? 0;

    return quantityStores > 0;
  }

  Future<StoreModel?> getLastStore() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$storeTable '
        'ORDER BY id DESC '
        'LIMIT 1';

    List<Map> storesMap = await database!.rawQuery(selectText);

    if (storesMap.isEmpty) return null;

    StoreModel store = StoreAdapter.fromRepository(storesMap[0]);

    return store;
  }

  Future<void> replaceAllDiacritics() async {
    List<StoreModel> stores = await getAll();
    for (StoreModel store in stores) {
      await update(store);
    }
  }
}
