import 'dart:io';

import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';

enum ListReplicateType {all, checked, unchecked}

sealed class ListEvent {
  const ListEvent();
}

final class ListStarted extends ListEvent {
  const ListStarted();
}

final class ListInserted extends ListEvent {
  ListInserted({required this.list, this.mold});

  final ListModel list;
  final MoldModel? mold;
}

final class ListUpdated extends ListEvent {
  const ListUpdated({required this.list});

  final ListModel list;
}

final class ListDeleted extends ListEvent {
  const ListDeleted({required this.list});

  final ListModel list;
}

final class SetCurrentList extends ListEvent {
  const SetCurrentList({required this.list});

  final ListModel list;
}

final class ListReplicated extends ListEvent {
  const ListReplicated({required this.list, required this.listReplicateType});

  final ListModel list;
  final ListReplicateType listReplicateType;
}

final class ListPicked extends ListEvent {
  const ListPicked();
}

final class ListImported extends ListEvent {
  const ListImported({required this.file});

  final File file;
}

final class ListImportedText extends ListEvent {
  const ListImportedText({required this.text});

  final String text;
}