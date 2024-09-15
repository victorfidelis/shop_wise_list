
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_event.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_state.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/repositories/product/product_repository.dart';
import 'package:shop_wise/app/repositories/product_mold/product_mold_repository.dart';

class ProductMoldBloc extends Bloc<ProductMoldEvent, ProductMoldState> {
  ProductMoldBloc() : super(const ProductMoldState()) {
    on<ProductMoldStarted>(_onProductMoldStarted);
    on<ProductSearched>(_onProductSearched);
    on<ProductTipSelected>(_onProductTipSelected);
    on<NameValidated>(_onProductListValidated);
    on<ProductMoldInserted>(_onProductMoldInserted);
    on<NewItem>(_onNewItem);
    on<ItemDeleted>(_onItemDeleted);
    on<SetFilter>(_onSetFilter);
    on<CategorySearched>(_onCategorySearched);
    on<CategorySelected>(_onCategorySelected);
  }

  void _onProductMoldStarted(ProductMoldStarted event, Emitter<ProductMoldState> emit) async {
    emit(state.copyWith(status: ProductMoldStatus.loading));

    ProductMoldRepository data = ProductMoldRepository();
    final List<ProductMoldModel> items = await data.getAll(event.mold);
    data.dispose();

    emit(state.copyWith(
      status: ProductMoldStatus.success,
      mold: event.mold,
      items: items,
    ));
  }

  void _onProductSearched(ProductSearched event, Emitter<ProductMoldState> emit) async {
    ProductRepository data = ProductRepository();
    List<ProductModel>? productsTips;

    if (event.text.trim().isEmpty)
      productsTips = [];
    else
      productsTips = await data.getLike(event.text.trim());

    data.dispose();

    emit(
      state.copyWith(
        productsTips: productsTips,
        product: ProductModel(name: event.text),
        nameError: '',
      ),
    );
  }

  void _onProductTipSelected(ProductTipSelected event, Emitter<ProductMoldState> emit) {
    emit(
      state.copyWith(
        productsTips: [],
        product: event.product,
        category: event.product.category,
        nameError: '',
      ),
    );
  }

  void _onProductListValidated(NameValidated event, Emitter<ProductMoldState> emit) {
    emit(
      state.copyWith(
        product: ProductModel(),
        nameError: event.nameError,
      ),
    );
  }

  Future<void> _onProductMoldInserted(
      ProductMoldInserted event, Emitter<ProductMoldState> emit) async {

    emit(state.copyWith(status: ProductMoldStatus.loading));

    ProductModel product = event.productMold.product;

    if (product.category != null &&
        product.category!.id == null &&
        product.category!.name.trim().isNotEmpty) {
      product = product.copyWith(category: await _insertCategory(category: product.category!));
    }

    ProductRepository dataProduct = ProductRepository();
    if (product.id == null) {
      product = await dataProduct.get(product.name) ?? await dataProduct.insert(product);
    } else {
      await dataProduct.update(product);
    }
    dataProduct.dispose();

    ProductMoldModel productMold = event.productMold.copyWith(product: product);

    ProductMoldRepository data = ProductMoldRepository();
    ProductMoldModel productMoldInserted = await data.insert(state.mold, productMold);
    data.dispose();

    emit(state.copyWith(
      status: ProductMoldStatus.success,
      items: state.items..insert(0, productMoldInserted),
      productsTips: [],
      product: ProductModel(),
    ));
  }

  Future<void> _onNewItem(NewItem event, Emitter<ProductMoldState> emit) async {
    emit(state.copyWith(
      productsTips: [],
      product: ProductModel(),
      category: CategoryModel(),
      nameError: '',
    ));
  }

  Future<void> _onItemDeleted(ItemDeleted event, Emitter<ProductMoldState> emit) async {
    emit(state.copyWith(status: ProductMoldStatus.loading));

    ProductMoldRepository data = ProductMoldRepository();
    await data.delete(event.productMold);
    data.dispose();

    emit(state.copyWith(
      status: ProductMoldStatus.success,
      items: state.items
        ..removeAt(
          state.items.indexWhere(
                (e) => e.id == event.productMold.id,
          ),
        ),
      deletedProductMold: event.productMold,
    ));
  }

  void _onSetFilter(SetFilter event, Emitter<ProductMoldState> emit) {
    List<ProductMoldModel> filteredItems = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredItems = state.items
          .where((e) => e.product.name.toUpperCase().contains(event.filter.toUpperCase()))
          .toList();
      isFilter = true;
    }

    emit(
      state.copyWith(
        filteredItems: filteredItems,
        isFilter: isFilter,
      ),
    );
  }

  void _onCategorySearched(CategorySearched event, Emitter<ProductMoldState> emit) async {
    CategoryRepository data = CategoryRepository();

    List<CategoryModel>? categoriesTips;
    if (event.text.trim().isEmpty)
      categoriesTips = [];
    else
      categoriesTips = await data.getLike(event.text.trim());

    data.dispose();

    emit(
      state.copyWith(
        categoriesTips: categoriesTips,
        category: CategoryModel(name: event.text),
      ),
    );
  }

  void _onCategorySelected(CategorySelected event, Emitter<ProductMoldState> emit) {
    emit(
      state.copyWith(
        categoriesTips: [],
        category: event.category,
      ),
    );
  }

  Future<CategoryModel> _insertCategory({required CategoryModel category}) async {

    CategoryRepository data = CategoryRepository();
    CategoryModel categoryInserted = await data.get(category.name) ?? await data.insert(category);
    data.dispose();

    return categoryInserted;
  }
}

