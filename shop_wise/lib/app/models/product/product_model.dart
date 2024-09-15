import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:shop_wise/app/models/category/category_model.dart';

class ProductModel {
  const ProductModel({this.id, this.category, this.name = ''});

  final int? id;
  final CategoryModel? category;
  final String name;

  String get nameWithoutDiacritics => replaceDiacritic(name);

  ProductModel copyWith({
    int? id,
    String? name,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
    );
  }

  bool isEquals(ProductModel product) {

    return product.id == this.id &&
        product.name == this.name &&
        (product.category?.id ?? 0) == (this.category?.id ?? 0);
  }
}
