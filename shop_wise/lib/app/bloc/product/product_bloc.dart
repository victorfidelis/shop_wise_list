import 'package:bloc/bloc.dart';
import 'package:shop_wise/app/bloc/product/product_event.dart';
import 'package:shop_wise/app/bloc/product/product_state.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/repositories/product/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<ProductStarted>(_onProductStarted);
    on<ProductInserted>(_onProductInserted);
    on<ProductUpdated>(_onProductUpdated);
    on<ProductDeleteValidated>(_onProductDeleteValidated);
    on<ProductDeleted>(_onProductDeleted);
    on<SetFilterProduct>(_onSetFilterProduct);
    on<CategorySearched>(_onCategorySearched);
    on<CategorySelected>(_onCategorySelected);
    on<NameValidated>(_onNameValidated);
  }

  Future<void> _onProductStarted(ProductStarted event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    ProductRepository data = ProductRepository();
    final List<ProductModel> products = await data.getAll();
    data.dispose();

    emit(state.copyWith(
      status: ProductStatus.success,
      products: products,
    ));
  }

  Future<void> _onProductInserted(ProductInserted event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    ProductModel product = event.product;

    if (product.category != null &&
        product.category!.id == null &&
        product.category!.name.trim().isNotEmpty) {
      product = product.copyWith(category: await _insertCategory(category: product.category!));
    }

    ProductRepository data = ProductRepository();
    ProductModel productInserted = await data.insert(product);
    data.dispose();

    emit(state.copyWith(
      status: ProductStatus.success,
      products: state.products..insert(0, productInserted),
    ));
  }

  Future<void> _onProductUpdated(ProductUpdated event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    ProductModel product = event.product;

    if (product.category != null &&
        product.category!.id == null &&
        product.category!.name.trim().isNotEmpty) {
      product = product.copyWith(category: await _insertCategory(category: product.category!));
    }

    ProductRepository data = ProductRepository();
    await data.update(product);
    data.dispose();

    List<ProductModel> products = state.products;
    products[products.indexWhere((e) => e.id == product.id)] = product;

    emit(state.copyWith(
      status: ProductStatus.success,
      products: products,
    ));
  }

  Future<void> _onProductDeleteValidated(
      ProductDeleteValidated event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    ProductRepository data = ProductRepository();
    bool productInList = await data.productInList(event.product);
    data.dispose();

    emit(state.copyWith(
      status: ProductStatus.success,
      deletedProductVerify: event.product,
      deletePermission: !productInList,
    ));
  }

  Future<void> _onProductDeleted(ProductDeleted event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    ProductRepository data = ProductRepository();
    await data.delete(event.product);
    data.dispose();

    List<ProductModel> products = state.products;
    products.removeWhere((e) => e.id == event.product.id);
    emit(state.copyWith(
      status: ProductStatus.success,
      products: products,
      deletedProduct: event.product,
    ));
  }

  void _onSetFilterProduct(SetFilterProduct event, Emitter<ProductState> emit) {
    List<ProductModel> filteredItems = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredItems = state.products
          .where((e) => e.name.toUpperCase().contains(event.filter.toUpperCase()))
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

  void _onCategorySearched(CategorySearched event, Emitter<ProductState> emit) async {
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

  void _onCategorySelected(CategorySelected event, Emitter<ProductState> emit) {
    emit(
      state.copyWith(
        categoriesTips: [],
        category: event.category,
      ),
    );
  }

  void _onNameValidated(NameValidated event, Emitter<ProductState> emit) {
    emit(
      state.copyWith(
        nameError: event.nameError,
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
