
import 'package:shop_wise/app/models/mold/mold_model.dart';

sealed class MoldEvent {
  const MoldEvent();
}

final class MoldStarted extends MoldEvent {
  MoldStarted({this.mold});

  final MoldModel? mold;
}

final class MoldInserted extends MoldEvent {
  const MoldInserted({ required this.mold});

  final MoldModel mold;
}

final class MoldUpdated extends MoldEvent {
  const MoldUpdated({required this.mold});

  final MoldModel mold;
}

final class MoldDeleted extends MoldEvent {
  const MoldDeleted({required this.mold});

  final MoldModel mold;
}

final class SetFilterMold extends MoldEvent {
  const SetFilterMold({required this.filter});

  final String filter;
}

final class MoldSelected extends MoldEvent {
  const MoldSelected({required this.mold});

  final MoldModel mold;
}


