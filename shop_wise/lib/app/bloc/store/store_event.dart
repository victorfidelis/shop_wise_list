import 'package:shop_wise/app/models/store/store_model.dart';

sealed class StoreEvent {
  const StoreEvent();
}

final class StoreStarted extends StoreEvent {
  const StoreStarted();
}

final class StoreInserted extends StoreEvent {
  const StoreInserted({ required this.store});

  final StoreModel store;
}

final class StoreUpdated extends StoreEvent {
  const StoreUpdated({required this.store});

  final StoreModel store;
}

final class StoreDeleteValidated extends StoreEvent {
  const StoreDeleteValidated({required this.store});

  final StoreModel store;
}

final class StoreDeleted extends StoreEvent {
  const StoreDeleted({required this.store});

  final StoreModel store;
}

final class SetFilterStore extends StoreEvent {
  const SetFilterStore({required this.filter});

  final String filter;
}