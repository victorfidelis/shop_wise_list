import 'package:replace_diacritic/replace_diacritic.dart';

class CategoryModel {
  const CategoryModel({
    this.id,
    this.name = '',
  });

  final int? id;
  final String name;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  CategoryModel copyWith({
    int? id,
    String? name,
    bool? dataVisible,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  bool isEquals(CategoryModel category) {
    return this.id == category.id && this.name == category.name;
  }
}
