import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';

sealed class EditListEvent {
  const EditListEvent();
}

final class EditListStarted extends EditListEvent {
  const EditListStarted({required this.list});

  final ListModel? list;
}

final class EditListSearched extends EditListEvent {
  const EditListSearched({required this.text});

  final String text;
}

final class EditListValidated extends EditListEvent {
  const EditListValidated({required this.nameError});

  final String nameError;
}

final class EditListSelected extends EditListEvent {
  const EditListSelected({required this.store});

  final StoreModel store;
}

final class EditListDateDefined extends EditListEvent {
  const EditListDateDefined({required this.date});

  final DateTime? date;
}

final class StoreInserted extends EditListEvent {
  const StoreInserted({required this.store});

  final StoreModel store;
}

final class SelectedMold extends EditListEvent {
  const SelectedMold({required this.mold});

  final MoldModel mold;
}