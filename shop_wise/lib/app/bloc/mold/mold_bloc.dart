
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_event.dart';
import 'package:shop_wise/app/bloc/mold/mold_state.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/repositories/mold/mold_repository.dart';

class MoldBloc extends Bloc<MoldEvent, MoldState> {
  MoldBloc() : super(const MoldState()) {
    on<MoldStarted>(_onMoldStarted);
    on<MoldInserted>(_onMoldInserted);
    on<MoldUpdated>(_onMoldUpdated);
    on<MoldDeleted>(_onMoldDeleted);
    on<SetFilterMold>(_onSetFilterMold);
    on<MoldSelected>(_onMoldSelected);
  }

  Future<void> _onMoldStarted(
      MoldStarted event, Emitter<MoldState> emit) async {

    emit(state.copyWith(status: MoldStatus.loading));

    MoldRepository data = MoldRepository();
    final List<MoldModel> molds = await data.getAll();
    data.dispose();

    int index = molds.indexWhere((e) => e.id == event.mold?.id);
    if (index >= 0 && event.mold != null)
      molds[index] = event.mold!;

    emit(state.copyWith(
      status: MoldStatus.success,
      molds: molds,
    ));
  }

  Future<void> _onMoldInserted(
      MoldInserted event, Emitter<MoldState> emit) async {

    emit(state.copyWith(status: MoldStatus.loading));

    MoldRepository data = MoldRepository();
    MoldModel moldInserted = await data.insert(event.mold);
    data.dispose();

    emit(state.copyWith(
      status: MoldStatus.success,
      molds: state.molds..insert(0, moldInserted),
    ));
  }

  Future<void> _onMoldUpdated(
      MoldUpdated event, Emitter<MoldState> emit) async {

    emit(state.copyWith(status: MoldStatus.loading));

    MoldRepository data = MoldRepository();
    await data.update(event.mold);
    data.dispose();

    List<MoldModel> molds = state.molds;
    molds[molds.indexWhere((e) => e.id == event.mold.id)] = event.mold;
    emit(state.copyWith(
      status: MoldStatus.success,
      molds: molds,
    ));
  }

  Future<void> _onMoldDeleted(
      MoldDeleted event, Emitter<MoldState> emit) async {

    emit(state.copyWith(status: MoldStatus.loading));

    MoldRepository data = MoldRepository();
    await data.delete(event.mold);
    data.dispose();

    List<MoldModel> molds = state.molds;
    molds.removeWhere((e) => e.id == event.mold.id);
    emit(state.copyWith(
      status: MoldStatus.success,
      molds: molds,
      deletedMold: event.mold,
    ));
  }

  void _onSetFilterMold(SetFilterMold event, Emitter<MoldState> emit) {
    List<MoldModel> filteredMolds = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredMolds = state.molds
          .where((e) => e.name.toUpperCase().contains(event.filter.toUpperCase()))
          .toList();
      isFilter = true;
    }

    emit(
      state.copyWith(
        filteredMolds: filteredMolds,
        isFilter: isFilter,
      ),
    );
  }

  void _onMoldSelected(MoldSelected event, Emitter<MoldState> emit) {
    List<MoldModel> molds = state.molds;
    int index = molds.indexWhere((e) => e.id == event.mold.id);

    bool selected = !molds[index].selected;
    if (selected) {
      molds = molds.map((e) => e.copyWith(selected: e.id == event.mold.id)).toList();
    } else {
      molds[index] = molds[index].copyWith(selected: selected);
    }

    List<MoldModel> filteredMolds = state.filteredMolds;
    if (state.isFilter) {
      if (selected) {
        filteredMolds = filteredMolds.map((e) => e.copyWith(selected: e.id == event.mold.id)).toList();
      } else {
        index = filteredMolds.indexWhere((e) => e.id == event.mold.id);
        filteredMolds[index] = filteredMolds[index].copyWith(selected: selected);
      }
    }

    emit(
      state.copyWith(
        molds: molds,
        filteredMolds: filteredMolds,
      ),
    );
  }
}