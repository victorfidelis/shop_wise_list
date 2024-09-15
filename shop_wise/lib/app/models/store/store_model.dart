import 'package:replace_diacritic/replace_diacritic.dart';

class StoreModel {
  const StoreModel({
    this.id,
    this.name = '',
  });

  final int? id;
  final String name;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  StoreModel copyWith({
    int? id,
    String? name,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  bool isEquals(StoreModel store) {
    return this.id == store.id && this.name == store.name;
  }
}
