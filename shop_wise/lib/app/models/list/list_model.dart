import 'package:shop_wise/app/models/store/store_model.dart';

class ListModel {
  final int? id;
  final StoreModel store;
  final double value;
  final DateTime? date;

  const ListModel({
    this.id,
    this.store = const StoreModel(),
    this.value = 0,
    this.date,
  });

  ListModel copyWith({
    int? id,
    StoreModel? store,
    double? value,
    DateTime? date,
  }) {
    return ListModel(
      id: id ?? this.id,
      store: store ?? this.store,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }

  bool isEquals(ListModel list) {
    return (id == list.id &&
        store.isEquals(list.store) &&
        value == list.value &&
        date == list.date);
  }
}
