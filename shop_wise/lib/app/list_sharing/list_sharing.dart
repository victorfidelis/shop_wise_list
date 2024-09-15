import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_wise/app/models/list/list_adapter.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_adapter.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/repositories/list/list_repository.dart';

class ListSharing {
  ListSharing({
    this.list = const ListModel(),
    this.items = const [],
  });

  final ListModel list;
  final List<ProductListModel> items;

  final NumberFormat quantityFormat = NumberFormat("###,###,##0.###", 'pt_BR');
  final NumberFormat priceFormat = NumberFormat("###,###,##0.00", 'pt_BR');

  double get totalShop {
    if (items.isEmpty) return 0;
    return items.map((e) => e.total).reduce((value, element) => value + element);
  }

  int get quantityShop {
    return items.length;
  }

  String getTextList({bool ignoreValues = false}) {
    String text = 'Loja: ${list.store.name}';
    String textDate = list.date == null ? '' : DateFormat('dd/MM/yyyy').format(list.date!);
    text += '\nData: $textDate';
    text += '\n\nItens: ';
    if (items.isNotEmpty) {
      String textItems = '\n';
      textItems += items
          .map((e) => sharedLine(productList: e, ignoreValues: ignoreValues))
          .reduce((e1, e2) => '$e1\n$e2');
      text += textItems;
    }

    text += '\n\n$quantityShop itens';

    if (ignoreValues) return text;

    text += '\nTotal: R\$${priceFormat.format(totalShop)}';

    return text;
  }

  String sharedLine({
    required ProductListModel productList,
    bool ignoreValues = false,
  }) {
    String textItem = '- ${productList.product.name}';
    if (ignoreValues) return textItem;

    bool hasValue = false;
    if (productList.quantity > 0) {
      textItem += ' (Qtde: ${quantityFormat.format(productList.quantity)}';
      hasValue = true;
    }
    if (hasValue && productList.price > 0) {
      textItem += ' - R\$ ${priceFormat.format(productList.price)}';
    } else if (productList.price > 0) {
      textItem += '(R\$ ${priceFormat.format(productList.price)}';
    }
    if (hasValue) textItem += ')';

    return textItem;
  }

  Future<File> generateExport() async {
    final Directory tempDir = await getTemporaryDirectory();
    String name = 'shop_list_${DateTime.now().millisecondsSinceEpoch}';
    name = name.replaceAll(RegExp(r'[^\w\s]+'), '_').replaceAll(' ', '_') + '.json';
    String fileName = '${tempDir.path}/${name}';
    File file = await File(fileName).writeAsString(json.encode(toMap()));
    return file;
  }

  Map toMap() {
    return {
      'list': ListAdapter.toMap(list),
      'items': items.map((e) => ProductListAdapter.toMap(e)).toList(),
    };
  }

  Future<File?> pickFileList() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return null;

    return File(result.files.single.path!);
  }

  Future<ListModel?> importFileList(File file) async {
    String jsonText = await file.readAsString();
    Map jsonMap = json.decode(jsonText);
    ListModel list = ListAdapter.fromMap(jsonMap['list']);

    List<ProductListModel> items = jsonMap['items']
        .map<ProductListModel>((e) => ProductListAdapter.fromMap(e))
        .toList();

    ListRepository listRepository = ListRepository();
    ListModel listImport = await listRepository.import(list, items);
    listRepository.dispose();

    return listImport;
  }

  Future<ListModel?> importTextList(String jsonText) async {
    Map jsonMap = json.decode(jsonText);
    ListModel list = ListAdapter.fromMap(jsonMap['list']);

    List<ProductListModel> items = jsonMap['items']
        .map<ProductListModel>((e) => ProductListAdapter.fromMap(e))
        .toList();

    ListRepository listRepository = ListRepository();
    ListModel listImport = await listRepository.import(list, items);
    listRepository.dispose();

    return listImport;
  }
}
