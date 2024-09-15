import 'package:shop_wise/app/models/store/store_model.dart';

enum StoreStatus { initial, loading, success, failure }

final class StoreState {
  const StoreState({
    this.status = StoreStatus.initial,
    this.stores = const <StoreModel>[],
    this.deletedStore,
    this.filteredStores = const [],
    this.isFilter = false,
    this.deletedStoreVerify,
    this.deletePermission = false,
  });

  final StoreStatus status;
  final List<StoreModel> stores;
  final StoreModel? deletedStore;
  final List<StoreModel> filteredStores;
  final bool isFilter;
  final StoreModel? deletedStoreVerify;
  final bool deletePermission;

  StoreState copyWith({
    StoreStatus? status,
    List<StoreModel>? stores,
    StoreModel? deletedStore,
    List<StoreModel>? filteredStores,
    bool? isFilter,
    StoreModel? deletedStoreVerify,
    bool? deletePermission,
  }) {
    return StoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      deletedStore: deletedStore,
      filteredStores: filteredStores ?? this.filteredStores,
      isFilter: isFilter ?? this.isFilter,
      deletedStoreVerify: deletedStoreVerify,
      deletePermission: deletePermission ?? this.deletePermission,
    );
  }
}
