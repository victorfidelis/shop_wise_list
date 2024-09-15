import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

class HistoryModel {
  const HistoryModel({
    required this.productList,
    required this.store,
    this.date,
  });

  final ProductListModel productList;
  final StoreModel store;
  final DateTime? date;

  HistoryModel copyWith({
    ProductListModel? productList,
    StoreModel? store,
    DateTime? date,
  }) {
    return HistoryModel(
      productList: productList ?? this.productList,
      store: store ?? this.store,
      date: date ?? this.date,
    );
  }
}
