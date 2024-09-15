import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_event.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_state.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/repositories/store/store_repository.dart';

class EditListBloc extends Bloc<EditListEvent, EditListState> {
  EditListBloc() : super(EditListState()) {
    on<EditListStarted>(_onEditListStarted);
    on<EditListSearched>(_onEditListSearched);
    on<EditListValidated>(_onEditListValidated);
    on<EditListSelected>(_onEditListSelected);
    on<EditListDateDefined>(_onEditListDateDefined);
    on<StoreInserted>(_onStoreInserted);
    on<SelectedMold>(_onSelectedMold);
  }

  void _onEditListStarted(EditListStarted event, Emitter<EditListState> emit) {
    emit(EditListState(
      list: event.list ?? ListModel(),
    ));
  }

  Future<void> _onEditListSearched(EditListSearched event, Emitter<EditListState> emit) async {

    StoreRepository data = StoreRepository();

    List<StoreModel>? storesTips;
    if (event.text.trim().isEmpty)
      storesTips = [];
    else
      storesTips = await data.getLike(event.text.trim());

    data.dispose();

    ListModel list = ListModel(
      id: state.list.id,
      store: StoreModel(),
      date: state.list.date,
    );

    emit(
      state.copyWith(
        list: list,
        storesTips: storesTips,
        nameError: '',
      ),
    );
  }

  void _onEditListValidated(EditListValidated event, Emitter<EditListState> emit) {
    emit(
      state.copyWith(nameError: event.nameError),
    );
  }

  void _onEditListSelected(EditListSelected event, Emitter<EditListState> emit) {
    emit(
      state.copyWith(
        list: state.list.copyWith(store: event.store),
        storesTips: [],
      ),
    );
  }

  void _onEditListDateDefined(EditListDateDefined event, Emitter<EditListState> emit) {
    ListModel list = state.list.copyWith(date: event.date);

    emit(
      state.copyWith(
        list: list,
        storesTips: [],
      ),
    );
  }

  Future<void> _onStoreInserted(StoreInserted event, Emitter<EditListState> emit) async {
    emit(state.copyWith(status: EditListStatus.loading));

    StoreRepository data = StoreRepository();
    StoreModel storeInserted = await data.insert(event.store);
    data.dispose();

    emit(state.copyWith(
      status: EditListStatus.success,
      list: state.list.copyWith(store: storeInserted),
      saveList: true,
    ));
  }

  Future<void> _onSelectedMold(SelectedMold event, Emitter<EditListState> emit) async {
    emit(state.copyWith(
      mold: event.mold,
    ));
  }
}
