import 'package:bloc/bloc.dart';
import 'package:shop_wise/app/bloc/store/store_event.dart';
import 'package:shop_wise/app/bloc/store/store_state.dart';
import 'package:shop_wise/app/repositories/store/store_repository.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(const StoreState()) {
    on<StoreStarted>(_onStoreStarted);
    on<StoreInserted>(_onStoreInserted);
    on<StoreUpdated>(_onStoreUpdated);
    on<StoreDeleteValidated>(_onStoreDeleteValidated);
    on<StoreDeleted>(_onStoreDeleted);
    on<SetFilterStore>(_onSetFilterStore);
  }

  Future<void> _onStoreStarted(
      StoreStarted event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: StoreStatus.loading));

    StoreRepository data = StoreRepository();
    final List<StoreModel> stores = await data.getAll();
    data.dispose();

    emit(state.copyWith(
      status: StoreStatus.success,
      stores: stores,
    ));
  }

  Future<void> _onStoreInserted(
      StoreInserted event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: StoreStatus.loading));

    StoreRepository data = StoreRepository();
    StoreModel storeInserted = await data.insert(event.store);
    data.dispose();

    emit(state.copyWith(
      status: StoreStatus.success,
      stores: state.stores..insert(0, storeInserted),
    ));
  }

  Future<void> _onStoreUpdated(
      StoreUpdated event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: StoreStatus.loading));

    StoreRepository data = StoreRepository();
    await data.update(event.store);
    data.dispose();

    List<StoreModel> stores = state.stores;
    stores[stores.indexWhere((e) => e.id == event.store.id)] = event.store;
    emit(state.copyWith(
      status: StoreStatus.success,
      stores: stores,
    ));
  }

  Future<void> _onStoreDeleteValidated(
      StoreDeleteValidated event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: StoreStatus.loading));

    StoreRepository data = StoreRepository();
    bool storeInList = await data.storeInList(event.store);
    data.dispose();

    emit(state.copyWith(
      status: StoreStatus.success,
      deletedStoreVerify: event.store,
      deletePermission: !storeInList,
    ));
  }

  Future<void> _onStoreDeleted(
      StoreDeleted event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: StoreStatus.loading));

    StoreRepository data = StoreRepository();
    await data.delete(event.store);
    data.dispose();

    List<StoreModel> stores = state.stores;
    stores.removeWhere((e) => e.id == event.store.id);
    emit(state.copyWith(
      status: StoreStatus.success,
      stores: stores,
      deletedStore: event.store,
    ));
  }

  void _onSetFilterStore(SetFilterStore event, Emitter<StoreState> emit) {
    List<StoreModel> filteredStores = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredStores = state.stores
          .where((e) => e.name.toUpperCase().contains(event.filter.toUpperCase()))
          .toList();
      isFilter = true;
    }

    emit(
      state.copyWith(
        filteredStores: filteredStores,
        isFilter: isFilter,
      ),
    );
  }
}
