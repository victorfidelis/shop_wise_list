import 'dart:io';

import 'package:shop_wise/app/models/list/list_model.dart';

abstract class ListState {
  final List<ListModel> lists;

  ListState({required this.lists});
}

class ListInitial extends ListState {
  ListInitial() : super(lists: []);
}

class ListLoading extends ListState {
  ListLoading() : super(lists: []);
}

class ListFailure extends ListState {
  ListFailure() : super(lists: []);
}

class ListComplete extends ListState {
  ListComplete({
    required List<ListModel> lists,
  }) : super(lists: lists);
}

class ListDelete extends ListComplete {
  ListDelete({
    required List<ListModel> lists,
    required this.deletedList,
  }) : super(lists: lists);

  ListModel deletedList;
}

class ListPickedSuccess extends ListComplete {
  ListPickedSuccess({
    required List<ListModel> lists,
    required this.importedFile,
  }) : super(lists: lists);

  File importedFile;
}

class ListMessage extends ListComplete {
  ListMessage({
    required List<ListModel> lists,
    required this.message,
  }) : super(lists: lists);

  String message;
}

class ListPickedFailure extends ListMessage {
  ListPickedFailure({
    required List<ListModel> lists,
    required String message,
  }) : super(lists: lists, message: message);
}

class ListImportList extends ListMessage {
  ListImportList({
    required List<ListModel> lists,
    required String message,
  }) : super(lists: lists, message: message);
}
