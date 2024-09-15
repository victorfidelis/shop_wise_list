import 'package:flutter_test/flutter_test.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/list/list_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/store/store_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late StoreRepositorySqflite storeRepository;
  late ListRepositorySqflite listRepository;
  late ProductListRepositorySqflite productListRepository;
  late ProductRepositorySqflite productRepository;

  late StoreModel firstStore;
  late StoreModel secondStore;

  late ListModel firstList;
  late ListModel secondList;

  late ProductModel firstProduct;
  late ProductModel secondProduct;
  late ProductModel thirdProduct;
  late ProductModel fourthProduct;

  late ProductListModel firstProductList;
  late ProductListModel secondProductList;
  late ProductListModel thirdProductList;
  late ProductListModel fourthProductList;

  Future<void> _initRepository() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await SqfliteSetup().setupDatabase(database);

    listRepository = ListRepositorySqflite(database: database);
    productListRepository = ProductListRepositorySqflite(database: database);
    productRepository = ProductRepositorySqflite(database: database);
    storeRepository = StoreRepositorySqflite(database: database);
  }

  Future<void> _includeStores() async {
    firstStore = await storeRepository.insert(StoreModel(name: 'Assaí'));
    secondStore = await storeRepository.insert(StoreModel(name: 'Extra'));
  }

  Future<void> _includeLists() async {
    firstList = await listRepository.insert(ListModel(store: firstStore));
    secondList = await listRepository.insert(ListModel(store: secondStore));
  }

  Future<void> _includeProduct() async {
    firstProduct = await productRepository.insert(ProductModel(name: 'Bolacha'));
    secondProduct = await productRepository.insert(ProductModel(name: 'Macarrão'));
    thirdProduct = await productRepository.insert(ProductModel(name: 'Arroz'));
    fourthProduct = await productRepository.insert(ProductModel(name: 'Feijão'));
  }

  setUpAll(() async {
    await _initRepository();
    await _includeStores();
    await _includeProduct();
    await _includeLists();
  });

  tearDownAll(() {
    storeRepository.dispose();
    listRepository.dispose();
    productRepository.dispose();
    productListRepository.dispose();
  });

  group(
    'Testes referente a classe ProductListRepositorySqflite da lista da loja "Assaí". '
        'Para efetuar o teste corretamente é importante não executar os '
        'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      test(
        'A primeira consulta de produtos de lista do firstList deve retornar uma lista de '
            'ProductListModel vazia',
            () async {
          List<ProductListModel> listProductList = await productListRepository.getAll(firstList);
          expect(listProductList.length, equals(0));
        },
      );

      test(
        'Ao inserir um produto ao firstList, a operação deve retornar um ProductListModel com id',
            () async {
          firstProductList = await productListRepository.insert(
            firstList,
            ProductListModel(product: firstProduct),
          );
          expect(firstProductList.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de produtos do firstList deve retornar uma lista com 1 '
            'ProductListModel igual a firstProductList',
            () async {
          List<ProductListModel> listProductList = await productListRepository.getAll(firstList);
          expect(listProductList.length, 1);
          expect(firstProductList.isEquals(listProductList[0]), equals(true));
        },
      );

      test(
        'Após um novo insert ao firstList, a consulta de produtos da firstList deve retornar uma '
            'lista com 2 ProductListModel',
            () async {
          secondProductList = await productListRepository.insert(
            firstList,
            ProductListModel(product: secondProduct),
          );
          List<ProductListModel> listProductList = await productListRepository.getAll(firstList);
          expect(listProductList.length, equals(2));
        },
      );

      test(
        'Ao consultar o último ProductListModel, deve retornar o secondProductList',
            () async {
          ProductListModel? productList = await productListRepository.getLastProductList();
          expect(productList?.isEquals(secondProductList), equals(true));
        },
      );

      test(
        'Ao alterar o firstProductList, o mesmo deve ser alterado no banco de dados sem alterar os '
            'demais registros',
            () async {
          firstProductList = firstProductList.copyWith(
            price: 5.99,
            quantity: 2,
            total: 11.98,
            check: true,
          );
          await productListRepository.update(firstProductList);
          List<ProductListModel> listProductList = await productListRepository.getAll(firstList);

          int firstListProductIndex = listProductList.indexWhere((e) => e.id == firstProductList.id);
          int secondListProductIndex = listProductList.indexWhere((e) => e.id == secondProductList.id);

          expect(firstProductList.isEquals(listProductList[firstListProductIndex]), equals(true));
          expect(secondProductList.isEquals(listProductList[secondListProductIndex]), equals(true));
        },
      );

      test(
        'Ao deletar o firstProductList do fisrtList o mesmo deve ser apagado do banco de dados',
            () async {
          await productListRepository.delete(firstProductList);
          List<ProductListModel> listProductList = await productListRepository.getAll(firstList);
          expect(listProductList.length, equals(1));
          expect(secondProductList.isEquals(listProductList[0]), equals(true));
        },
      );
    },
  );

  group(
    'Testes referente a classe ProductListRepositorySqflite da lista da loja "Extra". '
        'Para efetuar o teste corretamente é importante não executar os '
        'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
        () {
      test(
        'A primeira consulta de produtos de lista do secondList deve retornar uma lista de '
            'ProductListModel vazia',
            () async {
          List<ProductListModel> listProductList = await productListRepository.getAll(secondList);
          expect(listProductList.length, equals(0));
        },
      );

      test(
        'Ao inserir um produto ao secondList, a operação deve retornar um ProductListModel com id',
            () async {
          thirdProductList = await productListRepository.insert(
            secondList,
            ProductListModel(product: thirdProduct),
          );
          expect(thirdProductList.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de produtos do secondList deve retornar uma lista com 1 '
            'ProductListModel igual a thirdProductList',
            () async {
          List<ProductListModel> listProductList = await productListRepository.getAll(secondList);
          expect(listProductList.length, 1);
          expect(thirdProductList.isEquals(listProductList[0]), equals(true));
        },
      );

      test(
        'Após um novo insert ao secondList, a consulta de produtos da secondList deve retornar uma '
            'lista com 2 ProductListModel',
            () async {
          fourthProductList = await productListRepository.insert(
            secondList,
            ProductListModel(product: fourthProduct),
          );
          List<ProductListModel> listProductList = await productListRepository.getAll(secondList);
          expect(listProductList.length, equals(2));
        },
      );

      test(
        'Ao consultar o último ProductListModel, deve retornar o fouthProductList',
            () async {
          ProductListModel? productList = await productListRepository.getLastProductList();
          expect(productList?.isEquals(fourthProductList), equals(true));
        },
      );

      test(
        'Ao alterar o thirdProductList, o mesmo deve ser alterado no banco de dados sem alterar os '
            'demais registros',
            () async {
          thirdProductList = thirdProductList.copyWith(
            price: 5.99,
            quantity: 2,
            total: 11.98,
            check: true,
          );
          await productListRepository.update(thirdProductList);
          List<ProductListModel> listProductList = await productListRepository.getAll(secondList);

          int thirdListProductIndex = listProductList.indexWhere((e) => e.id == thirdProductList.id);
          int fourthListProductIndex = listProductList.indexWhere((e) => e.id == fourthProductList.id);

          expect(thirdProductList.isEquals(listProductList[thirdListProductIndex]), equals(true));
          expect(fourthProductList.isEquals(listProductList[fourthListProductIndex]), equals(true));
        },
      );

      test(
        'Ao deletar o thirdProductList do secondList o mesmo deve ser apagado do banco de dados',
            () async {
          await productListRepository.delete(thirdProductList);
          List<ProductListModel> listProductList = await productListRepository.getAll(secondList);
          expect(listProductList.length, equals(1));
          expect(fourthProductList.isEquals(listProductList[0]), equals(true));
        },
      );
    },
  );
}
