import 'package:shop_wise/app/models/category/category_model.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

final class CategoryStarted extends CategoryEvent {
  const CategoryStarted();
}

final class CategoryInserted extends CategoryEvent {
  const CategoryInserted({ required this.category});

  final CategoryModel category;
}

final class CategoryUpdated extends CategoryEvent {
  const CategoryUpdated({required this.category});

  final CategoryModel category;
}

final class CategoryDeleteValidated extends CategoryEvent {
  const CategoryDeleteValidated({required this.category});

  final CategoryModel category;
}

final class CategoryDeleted extends CategoryEvent {
  const CategoryDeleted({required this.category});

  final CategoryModel category;
}

final class SetFilterCategory extends CategoryEvent {
  const SetFilterCategory({required this.filter});

  final String filter;
}