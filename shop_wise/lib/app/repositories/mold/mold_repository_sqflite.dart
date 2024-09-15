
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:shop_wise/app/models/mold/mold_adapter.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqflite.dart';

class MoldRepositorySqflite implements MoldRepository {
  Database? database;
  String moldTable = '';
  String productMoldTable = '';

  MoldRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (moldTable.isEmpty) {
      moldTable = sqfliteSetup.moldTable;
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
  Future<void> delete(MoldModel moldModel) async {
    await _initDatabase();

    String deleteProductsText = ''
        'DELETE FROM '
        '$productMoldTable '
        'WHERE '
        'moldId = ?';

    List paramsProducts = [moldModel.id];
    await database!.rawDelete(deleteProductsText, paramsProducts);

    String deleteText = ''
        'DELETE FROM '
        '$moldTable '
        'WHERE '
        'id = ?';

    List params = [moldModel.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<List<MoldModel>> getAll() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$moldTable';

    List<Map> moldsMap = await database!.rawQuery(selectText);

    List<MoldModel> molds = moldsMap.map((moldMap) => MoldAdapter.fromRepository(moldMap)).toList();

    return molds;
  }

  @override
  Future<List<MoldModel>> getLike(String name) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name);

    String selectText = ""
        "SELECT "
        "id, name "
        "FROM "
        "$moldTable "
        "WHERE "
        "UPPER(nameWithoutDiacritic) like '%${nameWithoutDiacritic.trim().toUpperCase()}%'";

    List<Map> moldsMap = await database!.rawQuery(selectText);

    List<MoldModel> molds = moldsMap.map((moldMap) => MoldAdapter.fromRepository(moldMap)).toList();

    return molds;
  }

  @override
  Future<MoldModel> insert(MoldModel moldModel) async {
    await _initDatabase();

    String insert = 'INSERT INTO $moldTable (name, nameWithoutDiacritic) VALUES (?, ?)';
    List params = [moldModel.name.trim(), moldModel.nameWithoutDiacritics.trim()];
    await database!.rawInsert(insert, params);

    MoldModel moldInserted = (await getLastMold())!;

    return moldInserted;
  }

  @override
  Future<void> update(MoldModel moldModel) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $moldTable '
        'SET '
        'name = ? ,'
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      moldModel.name.trim(),
      moldModel.nameWithoutDiacritics.trim(),
      moldModel.id,
    ];
    await database!.rawUpdate(updateText, params);
  }

  Future<MoldModel?> getLastMold() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'id, name '
        'FROM '
        '$moldTable '
        'ORDER BY id DESC '
        'LIMIT 1';

    List<Map> moldsMap = await database!.rawQuery(selectText);

    if (moldsMap.isEmpty) return null;

    MoldModel mold = MoldAdapter.fromRepository(moldsMap[0]);

    return mold;
  }

  Future<void> replaceAllDiacritics() async {
    List<MoldModel> listMold = await getAll();
    for (MoldModel mold in listMold) {
      await update(mold);
    }
  }
}
