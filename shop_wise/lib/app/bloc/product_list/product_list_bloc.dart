import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_event.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_state.dart';
import 'package:shop_wise/app/list_sharing/list_sharing.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/repositories/product/product_repository.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc() : super(ProductListState()) {
    on<ProductListStarted>(_onProductListStarted);
    on<ProductSearched>(_onProductSearched);
    on<ProductTipSelected>(_onProductTipSelected);
    on<NameValidated>(_onProductListValidated);
    on<ProductListInserted>(_onProductListInserted);
    on<ProductListUpdated>(_onProductListUpdated);
    on<NewItem>(_onNewItem);
    on<ItemChanged>(_onItemChanged);
    on<ItemDeleted>(_onItemDeleted);
    on<SetFilter>(_onSetFilter);
    on<SetOrder>(_onSetOrder);
    on<ListExported>(_onListExported);
    on<ListSharedText>(_onListSharedText);
    on<CategorySearched>(_onCategorySearched);
    on<CategorySelected>(_onCategorySelected);
    on<CategoryChanged>(_onCategoryChanged);
    on<EncapsulateCategory>(_onEncapsulateCategory);
    on<ExpandCategory>(_onExpandCategory);
  }

  void _onProductListStarted(ProductListStarted event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    ProductListRepository data = ProductListRepository();
    final List<ProductListModel> items = await data.getAll(event.list);
    data.dispose();

    List<CategoryListModel> categories = getCategories(items: items);

    emit(state.copyWith(
      status: ProductListStatus.success,
      list: event.list,
      items: items,
      categories: categories,
    ));
  }

  void _onProductSearched(ProductSearched event, Emitter<ProductListState> emit) async {
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

  void _onProductTipSelected(ProductTipSelected event, Emitter<ProductListState> emit) {
    emit(
      state.copyWith(
        productsTips: [],
        product: event.product,
        nameError: '',
      ),
    );
  }

  void _onProductListValidated(NameValidated event, Emitter<ProductListState> emit) {
    emit(
      state.copyWith(
        product: ProductModel(),
        nameError: event.nameError,
      ),
    );
  }

  Future<void> _onProductListInserted(
      ProductListInserted event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    ProductModel product = event.productList.product;

    if (product.category != null &&
        product.category!.id == null &&
        product.category!.name.trim().isNotEmpty) {
      product = product.copyWith(category: await _insertCategory(category: product.category!));
    }

    ProductRepository dataProduct = ProductRepository();
    if (product.id == null) {
      product = await dataProduct.get(product.name) ?? await dataProduct.insert(product);
    }
    await dataProduct.update(product);
    dataProduct.dispose();

    ProductListModel productList = event.productList.copyWith(product: product);

    ProductListRepository data = ProductListRepository();
    ProductListModel productListInserted = await data.insert(state.list, productList);
    data.dispose();

    List<ProductListModel> items = state.items..insert(0, productListInserted);

    List<CategoryListModel> categories = getCategories(items: items);
    categories = updateCategories(
      previousCategories: state.categories,
      currentCategories: categories,
      categoryDataVisible: event.productList.product.category ??
          CategoryModel(
            id: 0,
            name: 'Sem categoria',
          ),
    );

    emit(state.copyWith(
      status: ProductListStatus.success,
      items: items,
      categories: categories,
      productsTips: [],
      product: ProductModel(),
    ));
  }

  Future<void> _onProductListUpdated(
      ProductListUpdated event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    ProductModel product = state.product;

    if (product.category != null &&
        product.category!.id == null &&
        product.category!.name.trim().isNotEmpty) {
      product = product.copyWith(category: await _insertCategory(category: product.category!));
    }

    ProductRepository dataProduct = ProductRepository();
    if (product.id == null) {
      product = await dataProduct.get(product.name) ?? await dataProduct.insert(product);
    }
    await dataProduct.update(product);
    dataProduct.dispose();

    ProductListModel productList = event.productList.copyWith(product: product);

    ProductListRepository data = ProductListRepository();
    await data.update(productList);
    data.dispose();

    state.items[state.items.indexWhere((e) => e.id == event.productList.id)] =
        event.productList.copyWith(product: product);

    if (state.filteredItems.any((e) => e.id == event.productList.id)) {
      state.filteredItems[state.filteredItems.indexWhere((e) => e.id == event.productList.id)] =
          event.productList.copyWith(product: product);
    }

    List<CategoryListModel> categories = getCategories(items: state.items);
    categories = updateCategories(
      previousCategories: state.categories,
      currentCategories: categories,
    );

    List<CategoryListModel> filteredCategories = getCategories(items: state.filteredItems);
    filteredCategories = updateCategories(
      previousCategories: state.filteredCategories,
      currentCategories: filteredCategories,
    );

    emit(state.copyWith(
      status: ProductListStatus.success,
      items: state.items,
      categories: categories,
      filteredItems: state.filteredItems,
      filteredCategories: filteredCategories,
      productsTips: [],
      product: ProductModel(),
    ));
  }

  Future<void> _onNewItem(NewItem event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(
      productsTips: [],
      product: ProductModel(),
      nameError: '',
    ));
  }

  Future<void> _onItemChanged(ItemChanged event, Emitter<ProductListState> emit) async {
    ProductListRepository data = ProductListRepository();
    await data.update(event.productList);
    data.dispose();

    state.items[state.items.indexWhere((e) => e.id == event.productList.id)] = event.productList;
  }

  Future<void> _onItemDeleted(ItemDeleted event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    ProductListRepository data = ProductListRepository();
    await data.delete(event.productList);
    data.dispose();

    emit(state.copyWith(
      status: ProductListStatus.success,
      items: state.items
        ..removeAt(
          state.items.indexWhere(
            (e) => e.id == event.productList.id,
          ),
        ),
      deletedProductList: event.productList,
    ));
  }

  void _onSetFilter(SetFilter event, Emitter<ProductListState> emit) {
    List<ProductListModel> filteredItems = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredItems = state.items
          .where((e) => e.product.name.toUpperCase().contains(event.filter.toUpperCase()))
          .toList();
      isFilter = true;
    }

    List<CategoryListModel> filteredCategories = getCategories(items: filteredItems);
    filteredCategories = updateCategories(
      previousCategories: state.categories,
      currentCategories: filteredCategories,
    );

    emit(
      state.copyWith(
        filteredItems: filteredItems,
        filteredCategories: filteredCategories,
        isFilter: isFilter,
      ),
    );
  }

  void _onSetOrder(SetOrder event, Emitter<ProductListState> emit) {
    if (event.order == ProductListOrder.check) {
      state.items.sort((i1, i2) {
        if (i1.check == i2.check)
          return 0;
        else if (i1.check)
          return 1;
        else
          return -1;
      });
    } else if (event.order == ProductListOrder.product) {
      state.items.sort((i1, i2) {
        return i1.product.name.toUpperCase().compareTo(i2.product.name.toUpperCase());
      });
      state.categories.sort((i1, i2) {
        return i1.category.name.toUpperCase().compareTo(i2.category.name.toUpperCase());
      });
    } else if (event.order == ProductListOrder.quantity) {
      state.items.sort((i1, i2) {
        return i1.quantity.compareTo(i2.quantity);
      });
      state.categories.sort((i1, i2) {
        return i1.quantity.compareTo(i2.quantity);
      });
    } else if (event.order == ProductListOrder.price) {
      state.items.sort((i1, i2) {
        return i1.price.compareTo(i2.price);
      });
      state.categories.sort((i1, i2) {
        return i1.price.compareTo(i2.price);
      });
    } else if (event.order == ProductListOrder.total) {
      state.items.sort((i1, i2) {
        return i1.total.compareTo(i2.total);
      });
      state.categories.sort((i1, i2) {
        return i1.total.compareTo(i2.total);
      });
    }

    emit(state.copyWith(items: state.items, categories: state.categories));
  }

  Future<void> _onListExported(ListExported event, Emitter<ProductListState> emit) async {
    ListSharing listSharing = ListSharing(list: state.list, items: state.items);
    File file = await listSharing.generateExport();
    await Share.shareXFiles(
      [XFile(file.path)],
    );
  }

  Future<void> _onListSharedText(ListSharedText event, Emitter<ProductListState> emit) async {
    ListSharing listSharing = ListSharing(list: state.list, items: state.items);
    Share.share(listSharing.getTextList(ignoreValues: event.ignoreValues));
  }

  void _onCategorySearched(CategorySearched event, Emitter<ProductListState> emit) async {
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
        product: state.product.copyWith(category: CategoryModel(name: event.text)),
      ),
    );
  }

  void _onCategorySelected(CategorySelected event, Emitter<ProductListState> emit) {
    emit(
      state.copyWith(
        categoriesTips: [],
        product: state.product.copyWith(category: event.category),
      ),
    );
  }

  Future<CategoryModel> _insertCategory({required CategoryModel category}) async {
    CategoryRepository data = CategoryRepository();
    CategoryModel categoryInserted = await data.get(category.name) ?? await data.insert(category);
    data.dispose();

    return categoryInserted;
  }

  Future<void> _onCategoryChanged(CategoryChanged event, Emitter<ProductListState> emit) async {
    state.categories[state.categories
        .indexWhere((e) => e.category.id == event.categoryList.category.id)] = event.categoryList;
  }

  Future<void> _onEncapsulateCategory(
    EncapsulateCategory event,
    Emitter<ProductListState> emit,
  ) async {
    List<CategoryListModel> categories =
        state.categories.map((e) => e.copyWith(dataVisible: false)).toList();

    emit(state.copyWith(
      categories: categories,
    ));
  }

  Future<void> _onExpandCategory(ExpandCategory event, Emitter<ProductListState> emit) async {
    List<CategoryListModel> categories =
        state.categories.map((e) => e.copyWith(dataVisible: true)).toList();

    emit(state.copyWith(
      categories: categories,
    ));
  }

  List<CategoryListModel> getCategories({
    required List<ProductListModel> items,
  }) {
    List<CategoryListModel> categories = [];

    for (ProductListModel item in items) {
      CategoryModel category = item.product.category ?? CategoryModel(id: 0, name: 'Sem categoria');
      if (category.name.isEmpty) {
        category = category.copyWith(id: 0, name: 'Sem categoria');
      }

      int index = categories.indexWhere((e) => (e.category.id ?? 0) == (category.id ?? 0));
      if (index >= 0) {
        categories[index] = categories[index].copyWith(
          quantity: categories[index].quantity + item.quantity,
          price: categories[index].price + item.price,
          total: categories[index].total + item.total,
          dataVisible: true,
        );
      } else {
        categories.add(CategoryListModel(
          category: category,
          quantity: item.quantity,
          price: item.price,
          total: item.total,
          dataVisible: true,
        ));
      }
    }

    return categories;
  }

  List<CategoryListModel> updateCategories({
    required List<CategoryListModel> previousCategories,
    required List<CategoryListModel> currentCategories,
    CategoryModel? categoryDataVisible,
  }) {
    List<CategoryListModel> categories = [];
    for (CategoryListModel categoryList in currentCategories) {
      List<CategoryListModel> tempCategories = previousCategories
          .where((e) => (e.category.id ?? 0) == (categoryList.category.id ?? 0))
          .toList();

      if (tempCategories.length > 0 &&
          (categoryDataVisible == null || categoryList.category.id != categoryDataVisible.id)) {
        categoryList = categoryList.copyWith(dataVisible: tempCategories[0].dataVisible);
      }

      categories.add(categoryList);
    }

    return categories;
  }
}
