import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/repositories/list/list_repository_sqflite.dart';

abstract class ListRepository {
  factory ListRepository() {
    return ListRepositorySqflite();
  }

  void dispose();
  Future<List<ListModel>> getAll();
  Future<void> update(ListModel listModel);
  Future<ListModel> insert(ListModel listModel, [MoldModel? mold]);
  Future<void> delete(ListModel listModel);
  Future<ListModel> replicate(ListModel listModel, ListReplicateType listReplicatedType);
  Future<ListModel> import(ListModel listModel, List<ProductListModel> items);
}