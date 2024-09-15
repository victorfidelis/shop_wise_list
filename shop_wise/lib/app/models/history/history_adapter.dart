import 'package:shop_wise/app/models/history/history_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_adapter.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

class HistoryAdapter {
  static HistoryModel fromRepository(Map map) {
    return HistoryModel(productList: ProductListAdapter.fromRepository(map),
        store: StoreModel(id: map['storeId'], name: map['storeName']),
        date: map['date'] == 0 ? null : DateTime.fromMillisecondsSinceEpoch(map['date']));
  }
}