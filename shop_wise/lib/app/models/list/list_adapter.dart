import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/store/store_adapter.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

class ListAdapter {
  static ListModel fromRepository(Map listMap) {
    return ListModel(
      id: listMap['id'],
      store: StoreModel(
        id: listMap['storeId'],
        name: listMap['storeName'],
      ),
      value: listMap['value'],
      date: listMap['date'] == 0
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(listMap['date']),
    );
  }

  static Map toMap(ListModel listMap) {
    return {
      'id': listMap.id,
      'date': listMap.date?.millisecondsSinceEpoch,
      'store': StoreAdapter.toMap(listMap.store),
      'value': listMap.value,
    };
  }
  static ListModel fromMap(Map listMap) {

    return ListModel(
      id: listMap['id'],
      store: StoreAdapter.fromMap(listMap['store']),
      value: listMap['value'],
      date: listMap['date'] == 0
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(listMap['date']),
    );
  }
}
