
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/list/list_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/product_mold/product_mold_repository_sqflite.dart';
import 'package:shop_wise/app/repositories/store/store_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late ListRepositorySqflite listRepository;
  late StoreRepositorySqflite storeRepository;
  late ProductRepositorySqflite productRepository;
  late MoldRepositorySqflite moldRepository;
  late ProductMoldRepositorySqflite productMoldRepository;
  late ProductListRepositorySqflite productListRepository;

  late StoreModel firstStore;
  late StoreModel secondStore;
  late StoreModel thirdStore;

  late ProductModel firstProduct;
  late ProductModel secondProduct;
  late ProductModel thirdProduct;

  late MoldModel firstMold;

  late ListModel firstList;
  late ListModel secondList;
  late ListModel thirdList;
  late ListModel fourthList;

  Future<void> _initRepositories() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await SqfliteSetup().setupDatabase(database);

    listRepository = ListRepositorySqflite(database: database);
    storeRepository = StoreRepositorySqflite(database: database);
    moldRepository = MoldRepositorySqflite(database: database);
    productMoldRepository = ProductMoldRepositorySqflite(database: database);
    productRepository = ProductRepositorySqflite(database: database);
    productListRepository = ProductListRepositorySqflite(database: database);
  }

  Future<void> _includeStores() async {
    firstStore = await storeRepository.insert(StoreModel(name: 'Assaí'));
    secondStore = await storeRepository.insert(StoreModel(name: 'Extra'));
    thirdStore = await storeRepository.insert(StoreModel(name: 'Carrefour'));
  }

  Future<void> _includeProducts() async {
    firstProduct = await productRepository.insert(ProductModel(name: 'Arros 5Kg'));
    secondProduct = await productRepository.insert(ProductModel(name: 'Feijão 1kg'));
    thirdProduct = await productRepository.insert(ProductModel(name: 'Macarrão'));
  }

  Future<void> _includeMolds() async {
    firstMold = await moldRepository.insert(MoldModel(name: 'Compras semanais'));
    await productMoldRepository.insert(
      firstMold,
      ProductMoldModel(product: firstProduct),
    );
    await productMoldRepository.insert(
      firstMold,
      ProductMoldModel(product: secondProduct),
    );
    await productMoldRepository.insert(
      firstMold,
      ProductMoldModel(product: thirdProduct),
    );
  }

  setUpAll(() async {
    await _initRepositories();
    await _includeStores();
    await _includeProducts();
    await _includeMolds();
  });

  tearDownAll(() {
    listRepository.dispose();
    storeRepository.dispose();
    moldRepository.dispose();
    productRepository.dispose();
  });

  group(
    'Testes referente a classe ListRepositorySqflite. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      test(
        'A primeira consulta de lista deve retornar uma lista de ListModel vazia',
        () async {
          List<ListModel> listList = await listRepository.getAll();
          expect(listList.length, equals(0));
        },
      );

      test(
        'Ao inserir uma lista a mesma deve retornar a mesma lista com id',
        () async {
          firstList = await listRepository.insert(ListModel(store: firstStore));
          expect(firstList.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de listas deve retornar uma lista com 1 ListModel igual a '
        'firstList',
        () async {
          List<ListModel> listList = await listRepository.getAll();
          expect(listList.length, 1);
          expect(firstList.isEquals(listList[0]), equals(true));
        },
      );

      test(
        'Após um novo insert, a consulta de listas deve retornar uma lista com 2 ListModel',
        () async {
          secondList = await listRepository.insert(ListModel(store: secondStore));
          List<ListModel> listList = await listRepository.getAll();
          expect(listList.length, equals(2));
        },
      );

      test(
        'Ao consultar a última lista, deve retornar o secondList',
        () async {
          ListModel? list = await listRepository.getLastList();
          expect(list?.isEquals(secondList), equals(true));
        },
      );

      test(
        'O update de uma lista deve alterá-la no banco de dados sem alterar as demais listas',
        () async {
          firstList = firstList.copyWith(store: thirdStore, date: DateTime(2024, 5, 25));
          await listRepository.update(firstList);
          List<ListModel> listList = await listRepository.getAll();

          expect(listList.length, equals(2));

          int firstListIndex = listList.indexWhere((e) => e.id == firstList.id);
          int secondListIndex = listList.indexWhere((e) => e.id == secondList.id);

          expect(firstList.isEquals(listList[firstListIndex]), equals(true));
          expect(secondList.isEquals(listList[secondListIndex]), equals(true));
        },
      );

      test(
        'Ao inserir uma lista com molde, os itens do molde devem ser inseridos a lista',
        () async {
          thirdList = await listRepository.insert(
            ListModel(store: thirdStore),
            firstMold,
          );

          List<ListModel> listList = await listRepository.getAll();
          int thirdListIndex = listList.indexWhere((e) => e.id == thirdList.id);
          expect(thirdList.isEquals(listList[thirdListIndex]), equals(true));

          List<ProductListModel> listProductList = await productListRepository.getAll(thirdList);
          expect(listProductList.length, equals(3));
        },
      );

      test(
        'Ao replicar uma lista, a nova lista deve ser igual a lista replicada, e, com '
        'os mesmos itens',
        () async {
          fourthList = await listRepository.replicate(thirdList, ListReplicateType.all);
          List<ListModel> listList = await listRepository.getAll();
          expect(listList.length, equals(4));

          int fourthListIndex = listList.indexWhere((e) => e.id == fourthList.id);
          expect(fourthList.isEquals(listList[fourthListIndex]), equals(true));
          expect(fourthList.store.isEquals(thirdList.store), equals(true));

          List<ProductListModel> fourthListProductList =
              await productListRepository.getAll(fourthList);
          List<ProductListModel> thirdListProductList =
              await productListRepository.getAll(thirdList);

          expect(fourthListProductList.length, equals(thirdListProductList.length));
          expect(fourthListProductList.length, equals(3));

          expect(
            fourthListProductList[0].product.isEquals(thirdListProductList[0].product),
            equals(true),
          );
          expect(
            fourthListProductList[1].product.isEquals(thirdListProductList[1].product),
            equals(true),
          );
          expect(
            fourthListProductList[2].product.isEquals(thirdListProductList[2].product),
            equals(true),
          );
        },
      );

      test(
        'Ao deletar uma lista a mesma deve ser apagada do banco de dados',
        () async {
          await listRepository.delete(firstList);
          List<ListModel> listList = await listRepository.getAll();
          expect(listList.length, equals(3));
          int secondListIndex = listList.indexWhere((e) => e.id == secondList.id);
          expect(secondList.isEquals(listList[secondListIndex]), equals(true));
        },
      );
    },
  );
}
