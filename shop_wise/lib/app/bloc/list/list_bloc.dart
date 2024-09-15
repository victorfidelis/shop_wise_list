import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/bloc/list/list_state.dart';
import 'package:shop_wise/app/list_sharing/list_sharing.dart';
import 'package:shop_wise/app/repositories/list/list_repository.dart';
import 'package:shop_wise/app/models/list/list_model.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListStarted>(_onListStarted);
    on<ListInserted>(_onListInserted);
    on<ListUpdated>(_onListUpdated);
    on<ListDeleted>(_onListDeleted);
    on<SetCurrentList>(_onSetCurrentList);
    on<ListReplicated>(_onListReplicated);
    on<ListPicked>(_onListPicked);
    on<ListImported>(_onListImported);
    on<ListImportedText>(_onListImportedText);
  }

  Future<void> _onListStarted(ListStarted event, Emitter<ListState> emit) async {
    emit(ListLoading());

    ListRepository data = ListRepository();
    final List<ListModel> lists = await data.getAll();
    data.dispose();

    emit(ListComplete(lists: lists));
  }

  Future<void> _onListInserted(ListInserted event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListRepository data = ListRepository();
    ListModel listInserted = await data.insert(event.list, event.mold);
    data.dispose();

    emit(ListComplete(lists: lists..insert(0, listInserted)));
  }

  Future<void> _onListUpdated(ListUpdated event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListRepository data = ListRepository();
    await data.update(event.list);
    data.dispose();

    lists[lists.indexWhere((e) => e.id == event.list.id)] = event.list;
    emit(ListComplete(lists: lists));
  }

  Future<void> _onListDeleted(ListDeleted event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListRepository data = ListRepository();
    await data.delete(event.list);
    data.dispose();

    lists.removeWhere((e) => e.id == event.list.id);
    emit(ListDelete(lists: lists, deletedList: event.list));
  }

  Future<void> _onSetCurrentList(SetCurrentList event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    lists[lists.indexWhere((e) => e.id == event.list.id)] = event.list;
    emit(ListComplete(lists: lists));
  }

  Future<void> _onListReplicated(ListReplicated event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListRepository data = ListRepository();
    ListModel listCloned = await data.replicate(event.list, event.listReplicateType);
    data.dispose();

    emit(ListComplete(lists: lists..insert(0, listCloned)));
  }

  Future<void> _onListPicked(ListPicked event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListSharing listSharing = ListSharing();
    File? file;
    bool error = false;
    try {
      file = await listSharing.pickFileList();
    } on Exception {
      error = true;
    }
    if (error) {
      emit(ListPickedFailure(
        lists: lists,
        message: "Ocorreu uma falha ao acessar o arquivo. Verifique se escolheu um arquivo válido.",
      ));
    } else if (file == null) {
      emit(ListComplete(lists: lists));
    } else {
      emit(ListPickedSuccess(lists: lists, importedFile: file));
    }
  }

  Future<void> _onListImported(ListImported event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListSharing listSharing = ListSharing();
    ListModel? list;
    bool error = false;
    String message;

    try {
      list = await listSharing.importFileList(event.file);
    } on Exception {
      error = true;
    }
    if (list != null) {
      lists.insert(0, list);
      message = "Lista importada";
    } else if (error) {
      message = "Ocorreu uma falha ao carregar o arquivo. Verifique se escolheu um arquivo válido.";
    } else {
      message = 'Ocorreu uma falha inesperada. Tente novamente mais tarde';
    }

    emit(ListImportList(lists: lists, message: message));
  }


  Future<void> _onListImportedText(ListImportedText event, Emitter<ListState> emit) async {
    List<ListModel> lists = state.lists;
    emit(ListLoading());

    ListSharing listSharing = ListSharing();
    ListModel? list;
    bool error = false;
    String message;

    try {
      list = await listSharing.importTextList(event.text);
    } on Exception {
      error = true;
    }
    if (list != null) {
      lists.insert(0, list);
      message = "Lista importada";
    } else if (error) {
      message = "Ocorreu uma falha ao carregar o arquivo. Verifique se escolheu um arquivo válido.";
    } else {
      message = 'Ocorreu uma falha inesperada. Tente novamente mais tarde';
    }

    emit(ListImportList(lists: lists, message: message));
  }
}
