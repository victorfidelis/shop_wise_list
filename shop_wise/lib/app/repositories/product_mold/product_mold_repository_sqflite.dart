
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_adapter.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/repositories/product_mold/product_mold_repository.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductMoldRepositorySqflite implements ProductMoldRepository {
  Database? database;
  String productMoldTable = '';
  String productTable = '';

  ProductMoldRepositorySqflite({this.database});

  Future<void> _initDatabase() async {
    SqfliteSetup sqfliteSetup = SqfliteSetup();
    if (database == null) {
      database = await sqfliteSetup.getDatabase();
    }
    if (productMoldTable.isEmpty) {
      productMoldTable = sqfliteSetup.productMoldTable;
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
  Future<void> delete(ProductMoldModel productMold) async{
    await _initDatabase();

    String deleteText = ''
        'DELETE FROM '
        '$productMoldTable '
        'WHERE '
        'id = ?';

    List params = [productMold.id];

    await database!.rawDelete(deleteText, params);
  }

  @override
  Future<List<ProductMoldModel>> getAll(MoldModel moldModel) async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'pmt.id, '
        'pt.id productId, '
        'pt.name productName '
        'FROM '
        '$productMoldTable pmt '
        'INNER JOIN $productTable pt on pmt.productId = pt.id '
        'WHERE '
        'pmt.moldId = ?';

    List param = [moldModel.id];
    List<Map> productMoldMap = await database!.rawQuery(selectText, param);

    List<ProductMoldModel> productsMold =
    productMoldMap.map((map) => ProductMoldAdapter.fromRepository(map)).toList();

    return productsMold;
  }

  @override
  Future<ProductMoldModel> insert(MoldModel mold, ProductMoldModel productMold) async {
    await _initDatabase();

    String insert = ''
        'INSERT INTO $productMoldTable ( '
        'moldId, '
        'productId'
        ') '
        'VALUES (?, ?)';
    List params = [
      mold.id,
      productMold.product.id,
    ];
    await database!.rawInsert(insert, params);

    ProductMoldModel productMoldInserted = (await getLastProductMold())!;

    return productMoldInserted;
  }

  Future<ProductMoldModel?> getLastProductMold() async {
    await _initDatabase();

    String selectText = ''
        'SELECT '
        'pmt.id, '
        'pt.id productId, '
        'pt.name productName '
        'FROM '
        '$productMoldTable pmt '
        'INNER JOIN $productTable pt on pmt.productId = pt.id '
        'ORDER BY pmt.id DESC '
        'LIMIT 1';

    List<Map> productsMap = await database!.rawQuery(selectText);

    if (productsMap.isEmpty) return null;

    ProductMoldModel product = ProductMoldAdapter.fromRepository(productsMap[0]);

    return product;
  }
}