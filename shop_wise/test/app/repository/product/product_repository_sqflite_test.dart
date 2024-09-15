import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/repositories/product/product_repository_sqflite.dart';
import 'package:shop_wise/app/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Testes referente a classe ProductRepositorySqflite. '
    'Para efetuar o teste corretamente é importante não executar os '
    'testes deste grupo de forma isolada, sempre executar o grupo inteiro.',
    () {
      late ProductRepositorySqflite productRepository;
      late ProductModel firstProduct;
      late ProductModel secondProduct;

      setUpAll(() async {
        sqfliteFfiInit();
        DatabaseFactory databaseFactory = databaseFactoryFfi;
        Database database = await databaseFactory.openDatabase(inMemoryDatabasePath);
        await SqfliteSetup().setupDatabase(database);

        productRepository = ProductRepositorySqflite(database: database);
      });

      tearDownAll(() {
        productRepository.dispose();
      });

      test('A primeira consulta de produtos deve retornar uma lista vazia', () async {
        List<ProductModel> products = await productRepository.getAll();
        expect(products.isEmpty, true);
      });

      test('O insert de um produto deve retornar um ProductModel com id', () async {
        firstProduct = await productRepository.insert(ProductModel(name: 'Bolacha'));
        expect(firstProduct.id != null, equals(true));
      });

      test(
        'Após o insert, a consulta de produtos deve retornar uma lista com 1 produto',
        () async {
          List<ProductModel> products = await productRepository.getAll();
          expect(products.length, equals(1));
        },
      );

      test('O update de um produto deve alterá-lo no banco de dados', () async {
        firstProduct = firstProduct.copyWith(name: 'Bolacha recheada');
        await productRepository.update(firstProduct);
        List<ProductModel> products = await productRepository.getAll();
        expect(firstProduct.isEquals(products[0]), true);
      });

      test(
        'Após um novo insert, a consulta de produtos deve retornar uma lista com 2 produtos',
        () async {
          secondProduct = await productRepository.insert(ProductModel(name: 'Macarrão'));
          List<ProductModel> products = await productRepository.getAll();
          expect(products.length, 2);
        },
      );

      test('Ao consultar o último produto, deve retornar o produto2', () async {
        ProductModel? productModel = await productRepository.getLastProduct();
        expect(productModel?.isEquals(secondProduct), true);
      });

      test('Ao executar o getLike passando "rech", deve retornar apenas o produto1', () async {
        List<ProductModel> products = await productRepository.getLike('rech');
        expect(products.length, 1);
        expect(products[0].isEquals(firstProduct), true);
      });

      test('Ao executar o getLike passando "maca", deve retornar apenas o produto2', () async {
        List<ProductModel> products = await productRepository.getLike('maca');
        expect(products.length, 1);
        expect(products[0].isEquals(secondProduct), true);
      });

      test('Ao executar o getLike passando "c", deve retornar o produto1 e o produto2', () async {
        List<ProductModel> products = await productRepository.getLike('c');
        expect(products.length, 2);
      });

      test('Ao executar o getLike passando "arroz", deve retornar uma lista vazia', () async {
        List<ProductModel> products = await productRepository.getLike('arroz');
        expect(products.length, 0);
      });

      test('Ao executar um get passando "macarra", deve retornar null', () async {
        ProductModel? product = await productRepository.get('macarra');
        expect(product, isNull);
      });

      test('Ao executar um get passando "macarrao", deve retornar o product2', () async {
        ProductModel? product = await productRepository.get('macarrao');
        expect(product, isNotNull);
        expect(product?.isEquals(secondProduct), equals(true));
      });

      test('Ao executar um get passando "macarrão", deve retornar o product2', () async {
        ProductModel? product = await productRepository.get('macarrão');
        expect(product, isNotNull);
        expect(product?.isEquals(secondProduct), equals(true));
      });

      test(
        'Após deletar o produto1, a consulta de produtos deve retornar uma lista com apenas o '
        'produto2',
        () async {
          await productRepository.delete(firstProduct);
          List<ProductModel> products = await productRepository.getAll();
          expect(products.length, 1);
          expect(secondProduct.isEquals(products[0]), equals(true));
        },
      );
    },
  );
}
