

import 'package:replace_diacritic/replace_diacritic.dart';

class MoldModel {
  const MoldModel({
    this.id,
    this.name = '',
    this.selected = false,
  });

  final int? id;
  final String name;
  final bool selected;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  MoldModel copyWith({
    int? id,
    String? name,
    bool? selected,
  }) {
    return MoldModel(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
    );
  }

  bool isEquals(MoldModel mold) {
    return (id == mold.id && name == mold.name);
  }
}
