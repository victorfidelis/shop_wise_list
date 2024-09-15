import 'package:shop_wise/app/models/mold/mold_model.dart';

class MoldAdapter {
  static MoldModel fromRepository(Map storeMap) {
    return MoldModel(
      id: storeMap['id'],
      name: storeMap['name'],
    );
  }
}
