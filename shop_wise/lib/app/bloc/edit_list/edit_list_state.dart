import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

enum EditListStatus { initial, loading, success, failure }

final class EditListState {
  EditListState({
    this.status = EditListStatus.initial,
    this.nameError = '',
    this.list = const ListModel(),
    this.storesTips = const [],
    this.saveList = false,
    this.mold = const MoldModel(name: ''),
  });

  final EditListStatus status;
  final String nameError;
  final ListModel list;
  final List<StoreModel> storesTips;
  final bool saveList;
  final MoldModel mold;

  EditListState copyWith({
    EditListStatus? status,
    String? nameError,
    ListModel? list,
    List<StoreModel>? storesTips,
    bool? saveList,
    MoldModel? mold,
  }) {
    return EditListState(
      status: status ?? this.status,
      nameError: nameError ?? this.nameError,
      list: list ?? this.list,
      storesTips: storesTips ?? this.storesTips,
      saveList: saveList ?? this.saveList,
      mold: mold ?? this.mold,
    );
  }
}
