
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/store/store_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Testes referente a classe StoreRepositorySqflite. '
        'Para efetuar o teste corretamente é importante não executar os '
        'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
        () {
      late StoreRepositorySqflite storeRepository;
      late StoreModel firstStore;
      late StoreModel secondStore;

      setUpAll(() async {
        sqfliteFfiInit();
        DatabaseFactory databaseFactory = databaseFactoryFfi;
        Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteSetup().setupDatabase(database);

        storeRepository = StoreRepositorySqflite(database: database);
      });

      test('A primeira consulta de lojas deve retornar uma lista vazia', () async {
        List<StoreModel> listStores = await storeRepository.getAll();
        expect(listStores.isEmpty, equals(true));
      });

      test('O insert de uma loja deve retornar um StoreModel com id', () async {
        firstStore = await storeRepository.insert(StoreModel(name: 'Assaí'));
        expect(firstStore.id, isNotNull);
      });

      test(
        'Após o insert, a consulta de lojas deve retornar uma lista com 1 loja',
            () async {
          List<StoreModel> listStores = await storeRepository.getAll();
          expect(listStores.length, 1);
        },
      );

      test('O update de uma loja deve alterá-la no banco de dados', () async {
        firstStore = firstStore.copyWith(name: 'Assaí João Dias');
        await storeRepository.update(firstStore);
        List<StoreModel> listStores = await storeRepository.getAll();
        expect(firstStore.isEquals(listStores[0]), equals(true));
      });

      test(
        'Após um novo insert, a consulta de lojas deve retornar uma lista com 2 lojas',
            () async {
          secondStore = await storeRepository.insert(StoreModel(name: 'Extra'));
          List<StoreModel> listStores = await storeRepository.getAll();
          expect(listStores.length, 2);
        },
      );

      test('Ao consultar a última loja, deve retornar o secondStore', () async {
        StoreModel? store = await storeRepository.getLastStore();
        expect(store?.isEquals(secondStore), equals(true));
      });

      test('Ao executar o getLike passando "ssaí J", deve retornar apenas o firstStore', () async {
        List<StoreModel> listStores = await storeRepository.getLike('ssaí J');
        expect(listStores.length, equals(1));
        expect(listStores[0].isEquals(firstStore), equals(true));
      });

      test('Ao executar o getLike passando "Ext", deve retornar apenas o secondStore', () async {
        List<StoreModel> listStores = await storeRepository.getLike('Ext');
        expect(listStores.length, equals(1));
        expect(listStores[0].isEquals(secondStore), equals(true));
      });

      test('Ao executar o getLike passando "a", deve retornar o firstStore e o secondStore', () async {
        List<StoreModel> listStore = await storeRepository.getLike('a');
        expect(listStore.length, equals(2));
      });

      test('Ao executar o getLike passando "Loja", deve retornar uma lista vazia', () async {
        List<StoreModel> listStore = await storeRepository.getLike('Loja');
        expect(listStore.length, equals(0));
      });

      test('Ao executar um get passando "Extr", deve retornar null', () async {
        StoreModel? store = await storeRepository.get('Extr');
        expect(store, isNull);
      });

      test('Ao executar um get passando "assai joao dias", deve retornar o firstStore', () async {
        StoreModel? store = await storeRepository.get('assai joao dias');
        expect(store, isNotNull);
        expect(store?.isEquals(firstStore), equals(true));
      });

      test('Ao executar um get passando "Assaí João Dias", deve retornar o firstStore', () async {
        StoreModel? store = await storeRepository.get('Assaí João Dias');
        expect(store, isNotNull);
        expect(store?.isEquals(firstStore), equals(true));
      });

      test(
        'Após deletar o firstStore, a consulta de lojas deve retornar uma lista com apenas o '
            'secondProduct',
            () async {
          await storeRepository.delete(firstStore);
          List<StoreModel> listStores = await storeRepository.getAll();
          expect(listStores.length, 1);
          expect(secondStore.isEquals(listStores[0]), equals(true));
        },
      );
    },
  );
}
