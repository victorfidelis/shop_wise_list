import 'package:shop_wise/app/models/mold/mold_model.dart';

enum MoldStatus { initial, loading, success, failure }

final class MoldState {
  const MoldState({
    this.status = MoldStatus.initial,
    this.molds = const <MoldModel>[],
    this.deletedMold,
    this.filteredMolds = const [],
    this.isFilter = false,
  });

  final MoldStatus status;
  final List<MoldModel> molds;
  final List<MoldModel> filteredMolds;
  final MoldModel? deletedMold;
  final bool isFilter;

  MoldModel get selectedMold {
    int index = molds.indexWhere((e) => e.selected);
    if (index == -1) return MoldModel(name: '');
    return molds[index];
  }

  MoldState copyWith({
    MoldStatus? status,
    List<MoldModel>? molds,
    MoldModel? deletedMold,
    List<MoldModel>? filteredMolds,
    bool? isFilter,
  }) {
    return MoldState(
      status: status ?? this.status,
      molds: molds ?? this.molds,
      deletedMold: deletedMold,
      filteredMolds: filteredMolds ?? this.filteredMolds,
      isFilter: isFilter ?? this.isFilter,
    );
  }
}
