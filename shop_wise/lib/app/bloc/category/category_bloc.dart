import 'package:bloc/bloc.dart';
import 'package:shop_wise/app/bloc/category/category_event.dart';
import 'package:shop_wise/app/bloc/category/category_state.dart';
import 'package:shop_wise/app/repositories/category/category_repository.dart';
import 'package:shop_wise/app/models/category/category_model.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<CategoryStarted>(_onCategoryStarted);
    on<CategoryInserted>(_onCategoryInserted);
    on<CategoryUpdated>(_onCategoryUpdated);
    on<CategoryDeleteValidated>(_onCategoryDeleteValidated);
    on<CategoryDeleted>(_onCategoryDeleted);
    on<SetFilterCategory>(_onSetFilterCategory);
  }

  Future<void> _onCategoryStarted(
      CategoryStarted event, Emitter<CategoryState> emit) async {

    emit(state.copyWith(status: CategoryStatus.loading));

    CategoryRepository data = CategoryRepository();
    final List<CategoryModel> categories = await data.getAll();
    data.dispose();

    emit(state.copyWith(
      status: CategoryStatus.success,
      categories: categories,
    ));
  }

  Future<void> _onCategoryInserted(
      CategoryInserted event, Emitter<CategoryState> emit) async {

    emit(state.copyWith(status: CategoryStatus.loading));

    CategoryRepository data = CategoryRepository();
    CategoryModel categoryInserted = await data.insert(event.category);
    data.dispose();

    emit(state.copyWith(
      status: CategoryStatus.success,
      categories: state.categories..insert(0, categoryInserted),
    ));
  }

  Future<void> _onCategoryUpdated(
      CategoryUpdated event, Emitter<CategoryState> emit) async {

    emit(state.copyWith(status: CategoryStatus.loading));

    CategoryRepository data = CategoryRepository();
    await data.update(event.category);
    data.dispose();

    List<CategoryModel> categories = state.categories;
    categories[categories.indexWhere((e) => e.id == event.category.id)] = event.category;
    emit(state.copyWith(
      status: CategoryStatus.success,
      categories: categories,
    ));
  }

  Future<void> _onCategoryDeleteValidated(
      CategoryDeleteValidated event, Emitter<CategoryState> emit) async {

    emit(state.copyWith(status: CategoryStatus.loading));

    CategoryRepository data = CategoryRepository();
    bool categoryInList = await data.categoryInProduct(event.category);
    data.dispose();

    emit(state.copyWith(
      status: CategoryStatus.success,
      deletedCategoryVerify: event.category,
      deletePermission: !categoryInList,
    ));
  }

  Future<void> _onCategoryDeleted(
      CategoryDeleted event, Emitter<CategoryState> emit) async {

    emit(state.copyWith(status: CategoryStatus.loading));

    CategoryRepository data = CategoryRepository();
    await data.delete(event.category);
    data.dispose();

    List<CategoryModel> categories = state.categories;
    categories.removeWhere((e) => e.id == event.category.id);
    emit(state.copyWith(
      status: CategoryStatus.success,
      categories: categories,
      deletedCategory: event.category,
    ));
  }

  void _onSetFilterCategory(SetFilterCategory event, Emitter<CategoryState> emit) {
    List<CategoryModel> filteredCategorys = [];
    bool isFilter = false;

    if (event.filter.trim().isNotEmpty) {
      filteredCategorys = state.categories
          .where((e) => e.name.toUpperCase().contains(event.filter.toUpperCase()))
          .toList();
      isFilter = true;
    }

    emit(
      state.copyWith(
        filteredCategories: filteredCategorys,
        isFilter: isFilter,
      ),
    );
  }
}
