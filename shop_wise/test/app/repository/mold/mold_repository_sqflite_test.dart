import 'package:flutter_test/flutter_test.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late MoldRepositorySqflite moldRepository;

  late MoldModel firstMold;
  late MoldModel secondMold;

  Future<void> _initRepositories() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await SqfliteSetup().setupDatabase(database);

    moldRepository = MoldRepositorySqflite(database: database);
  }

  setUpAll(
    () async {
      await _initRepositories();
    },
  );

  tearDownAll(
    () {
      moldRepository.dispose();
    },
  );

  group(
    'Testes referente a classe MoldRepositorySqflite. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      test(
        'A primeira consulta de moldes deve retornar uma lista de ListMold vazia',
        () async {
          List<MoldModel> listMold = await moldRepository.getAll();
          expect(listMold.length, equals(0));
        },
      );

      test(
        'Ao inserir um molde deve-se retornar o mesmo molde com id',
        () async {
          firstMold = await moldRepository.insert(MoldModel(name: 'Compras semanais'));
          expect(firstMold.id, isNotNull);
        },
      );

      test(
        'Após o insert, a consulta de moldes deve retornar uma lista com 1 MoldModel igual a '
        'firstMold',
        () async {
          List<MoldModel> listMold = await moldRepository.getAll();
          expect(listMold.length, 1);
          expect(firstMold.isEquals(listMold[0]), equals(true));
        },
      );

      test(
        'Após o insert, a consulta de moldes deve retornar uma lista com 1 MoldModel igual a '
        'firstMold',
        () async {
          List<MoldModel> listMold = await moldRepository.getAll();
          expect(listMold.length, 1);
          expect(firstMold.isEquals(listMold[0]), equals(true));
        },
      );

      test(
        'Após um novo insert, a consulta de moldes deve retornar uma lista com 2 MoldModel',
        () async {
          secondMold = await moldRepository.insert(MoldModel(name: 'Compras mensais'));
          List<MoldModel> listMold = await moldRepository.getAll();
          expect(listMold.length, equals(2));
        },
      );

      test(
        'Ao consultar o último molde, deve retornar o secondMold',
        () async {
          MoldModel? mold = await moldRepository.getLastMold();
          expect(mold?.isEquals(secondMold), equals(true));
        },
      );

      test(
        'O update de um molde deve alterá-lo no banco de dados sem alterar os demais moldes',
        () async {
          firstMold = firstMold.copyWith(name: 'Compras diárias');
          await moldRepository.update(firstMold);
          List<MoldModel> listMold = await moldRepository.getAll();

          expect(listMold.length, equals(2));

          int firstMoldIndex = listMold.indexWhere((e) => e.id == firstMold.id);
          int secondMoldIndex = listMold.indexWhere((e) => e.id == secondMold.id);

          expect(firstMold.isEquals(listMold[firstMoldIndex]), equals(true));
          expect(secondMold.isEquals(listMold[secondMoldIndex]), equals(true));
        },
      );

      test(
        'Ao executar o getLike passando "dia", deve retornar apenas o firstMold',
        () async {
          List<MoldModel> listMold = await moldRepository.getLike('dia');
          expect(listMold.length, 1);
          expect(listMold[0].isEquals(firstMold), true);
        },
      );

      test(
        'Ao executar o getLike passando "mensa", deve retornar apenas o secondMold',
        () async {
          List<MoldModel> listMold = await moldRepository.getLike('mensa');
          expect(listMold.length, 1);
          expect(listMold[0].isEquals(secondMold), true);
        },
      );

      test(
        'Ao executar o getLike passando "compra", deve retornar o firstMold e o secondMold',
        () async {
          List<MoldModel> listMold = await moldRepository.getLike('compra');
          expect(listMold.length, 2);
        },
      );

      test(
        'Após deletar o fisrtMold, a consulta de moldes deve retornar uma lista com apenas o '
        'secondMold',
        () async {
          await moldRepository.delete(firstMold);
          List<MoldModel> listMold = await moldRepository.getAll();
          expect(listMold.length, 1);
          expect(secondMold.isEquals(listMold[0]), equals(true));
        },
      );
    },
  );
}
