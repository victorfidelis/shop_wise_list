import 'package:shop_wise/app/models/store/store_model.dart';

class StoreAdapter {
  static StoreModel fromRepository(Map storeMap) {
    return StoreModel(
      id: storeMap['id'],
      name: storeMap['name'],
    );
  }

  static Map toMap(StoreModel store) {
    return {
      'id': store.id,
      'name': store.name,
    };
  }

  static StoreModel fromMap(Map storeMap) {
    return StoreModel(
      id: storeMap['id'],
      name: storeMap['name'],
    );
  }
}
