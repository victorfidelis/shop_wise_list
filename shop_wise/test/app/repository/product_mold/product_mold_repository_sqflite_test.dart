import 'package:flutter_test/flutter_test.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product_mold/product_mold_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late MoldRepositorySqflite moldRepository;
  late ProductMoldRepositorySqflite productMoldRepository;
  late ProductRepositorySqflite productRepository;

  late MoldModel firstMold;
  late MoldModel secondMold;

  late ProductModel firstProduct;
  late ProductModel secondProduct;
  late ProductModel thirdProduct;
  late ProductModel fourthProduct;

  late ProductMoldModel firstProductMold;
  late ProductMoldModel secondProductMold;
  late ProductMoldModel thirdProductMold;
  late ProductMoldModel fourthProductMold;

  Future<void> _initRepository() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await SqfliteSetup().setupDatabase(database);

    moldRepository = MoldRepositorySqflite(database: database);
    productMoldRepository = ProductMoldRepositorySqflite(database: database);
    productRepository = ProductRepositorySqflite(database: database);
  }

  Future<void> _includeMolds() async {
    firstMold = await moldRepository.insert(MoldModel(name: 'Compras semanais'));
    secondMold = await moldRepository.insert(MoldModel(name: 'Churrasco'));
  }

  Future<void> _includeProduct() async {
    firstProduct = await productRepository.insert(ProductModel(name: 'Bolacha'));
    secondProduct = await productRepository.insert(ProductModel(name: 'Macarrão'));
    thirdProduct = await productRepository.insert(ProductModel(name: 'Arroz'));
    fourthProduct = await productRepository.insert(ProductModel(name: 'Feijão'));
  }

  setUpAll(() async {
    await _initRepository();
    await _includeMolds();
    await _includeProduct();
  });

  tearDownAll(() {
    moldRepository.dispose();
    productRepository.dispose();
    productMoldRepository.dispose();
  });

  group(
    'Testes referente a classe ProductMoldRepositorySqflite do modelo "Compras semanais". '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      test(
        'A primeira consulta de produtos de modelo do firstMold deve retornar uma lista de '
        'ProductMoldModel vazia',
        () async {
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(firstMold);
          expect(listProductMold.length, equals(0));
        },
      );

      test(
        'Ao inserir um produto ao firstMold, a operação deve retornar um ProductMoldModel com id',
        () async {
          firstProductMold = await productMoldRepository.insert(
            firstMold,
            ProductMoldModel(product: firstProduct),
          );
          expect(firstProductMold.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de produtos do firstMold deve retornar uma lista com 1 '
        'ProductMoldModel igual a firstProductList',
        () async {
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(firstMold);
          expect(listProductMold.length, 1);
          expect(firstProductMold.isEquals(listProductMold[0]), equals(true));
        },
      );

      test(
        'Após um novo insert ao firstMold, a consulta de produtos da firstMold deve retornar uma '
        'lista com 2 ProductMoldModel',
        () async {
          secondProductMold = await productMoldRepository.insert(
            firstMold,
            ProductMoldModel(product: secondProduct),
          );
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(firstMold);
          expect(listProductMold.length, equals(2));
        },
      );

      test(
        'Ao consultar o último ProductMoldModel, deve retornar o secondProductMold',
            () async {
          ProductMoldModel? productMold = await productMoldRepository.getLastProductMold();
          expect(productMold?.isEquals(secondProductMold), equals(true));
        },
      );

      test(
        'Ao deletar o firstProductMold do fisrtMold o mesmo deve ser apagado do banco de dados',
            () async {
          await productMoldRepository.delete(firstProductMold);
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(firstMold);
          expect(listProductMold.length, equals(1));
          expect(secondProductMold.isEquals(listProductMold[0]), equals(true));
        },
      );
    },
  );

  group(
    'Testes referente a classe ProductMoldRepositorySqflite do modelo "Compras mensais". '
        'Para efetuar o teste corretamente é importante não executar os '
        'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
        () {
      test(
        'A primeira consulta de produtos de modelo do secondModel deve retornar uma lista de '
            'ProductMoldModel vazia',
            () async {
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(secondMold);
          expect(listProductMold.length, equals(0));
        },
      );

      test(
        'Ao inserir um produto ao secondMold, a operação deve retornar um ProductMoldModel com id',
            () async {
          thirdProductMold = await productMoldRepository.insert(
            secondMold,
            ProductMoldModel(product: thirdProduct),
          );
          expect(firstProductMold.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de produtos do secondMold deve retornar uma lista com 1 '
            'ProductMoldModel igual a thirdProductList',
            () async {
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(secondMold);
          expect(listProductMold.length, 1);
          expect(thirdProductMold.isEquals(listProductMold[0]), equals(true));
        },
      );

      test(
        'Após um novo insert ao secondMold, a consulta de produtos da secondMold deve retornar uma '
            'lista com 2 ProductMoldModel',
            () async {
          fourthProductMold = await productMoldRepository.insert(
            secondMold,
            ProductMoldModel(product: fourthProduct),
          );
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(secondMold);
          expect(listProductMold.length, equals(2));
        },
      );

      test(
        'Ao consultar o último ProductMoldModel, deve retornar o fourthProductMold',
            () async {
          ProductMoldModel? productMold = await productMoldRepository.getLastProductMold();
          expect(productMold?.isEquals(fourthProductMold), equals(true));
        },
      );

      test(
        'Ao deletar o thirdProductMold do secondMold o mesmo deve ser apagado do banco de dados',
            () async {
          await productMoldRepository.delete(thirdProductMold);
          List<ProductMoldModel> listProductMold = await productMoldRepository.getAll(secondMold);
          expect(listProductMold.length, equals(1));
          expect(fourthProductMold.isEquals(listProductMold[0]), equals(true));
        },
      );
    },
  );
}
