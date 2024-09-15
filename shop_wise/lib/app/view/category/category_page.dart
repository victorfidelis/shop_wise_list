import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/category/category_bloc.dart';
import 'package:shop_wise/app/bloc/category/category_event.dart';
import 'package:shop_wise/app/bloc/category/category_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/category/widgets/category_tile_format.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<CategoryBloc>().add(const CategoryStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        if (searchController.text.trim().isNotEmpty) {
          searchController.clear();
          _onSearchChanged();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 120,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2a99a8),
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            opacity: 0.8,
                            image: AssetImage(
                              'assets/images/background_00.jpg',
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Minhas categorias',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverFixedHeaderDelegate(
                        minHeight: 45,
                        maxHeight: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
                          child: SearchComponent(
                            controller: searchController,
                            onChanged: _onSearchChanged,
                            hintText: 'Filtre pelo nome da categoria',
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<CategoryBloc, CategoryState>(
                      listener: (context, state) {
                        if (state.deletedCategory != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message: 'Categoria "${state.deletedCategory!.name}" excluída',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context
                                    .read<CategoryBloc>()
                                    .add(CategoryInserted(category: state.deletedCategory!));
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == CategoryStatus.initial ||
                            state.status == CategoryStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == CategoryStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta das categorias',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state.categories.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhuma categoria cadastrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        int length =
                            state.isFilter ? state.filteredCategories.length : state.categories.length;

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverList.builder(
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index >= length) return SizedBox(height: 90);

                              CategoryModel category =
                                  state.isFilter ? state.filteredCategories[index] : state.categories[index];

                              return CategoryTileFormat(
                                  category: category,
                                  onTap: () {
                                    _onTapCategory(category);
                                  },
                                  onLongPress: () {
                                    _onLongPressCategory(category);
                                  });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ButtonFormat(
          onPressed: _goToEditCategory,
          text: 'Criar nova categoria',
          icon: Icons.add,
        ),
      ),
    );
  }

  void _goToEditCategory({CategoryModel? category}) {
    bool isChange = category != null;
    String categoryName = '';
    TextEditingController nameController = TextEditingController();

    nameController.text = category?.name ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category?.name ?? 'Nova categoria'),
          content: TextField(
            controller: nameController,
            onChanged: (value) {
              categoryName = value;
            },
          ),
          actions: [
            ButtonFormat(
              onPressed: () {
                if (categoryName.isEmpty) return;

                if (isChange) {
                  context.read<CategoryBloc>().add(
                        CategoryUpdated(
                          category: category.copyWith(name: categoryName),
                        ),
                      );
                } else {
                  context.read<CategoryBloc>().add(
                        CategoryInserted(
                          category: CategoryModel(name: categoryName),
                        ),
                      );
                }
                Navigator.pop(context);
              },
              text: 'Salvar categoria',
              icon: Icons.save,
            ),
          ],
        );
      },
    );
  }

  void _onTapCategory(CategoryModel category) {
    _goToEditCategory(category: category);
  }

  void _onLongPressCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<CategoryBloc, CategoryState>(listener: (context, state) {
          if (state.status == CategoryStatus.loading) return;

          if (state.deletedCategoryVerify != null) {
            if (state.deletePermission) {
              Navigator.pop(context);
              context.read<CategoryBloc>().add(CategoryDeleted(category: category));
            } else {
              AlertDialog alert = AlertDialog(
                title: Text('Exclusão negada'),
                content: Text('Categoria "${state.deletedCategoryVerify!.name}" não pode ser excluída '
                    'pois está cadastrada em algum produto'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok')),
                ],
              );

              showDialog(context: context, builder: (context) => alert);
            }
          }
        }, builder: (context, state) {
          if (state.status == CategoryStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return MenuButtonDialog(
            buttons: [
              ButtonDialogModel(
                text: 'Editar',
                onPressed: () {
                  Navigator.pop(context);
                  _onTapCategory(category);
                },
                icon: Icons.edit,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Excluir',
                onPressed: () {
                  context.read<CategoryBloc>().add(CategoryDeleteValidated(category: category));
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
              ),
            ],
          );
        });
      },
    );
  }

  void _onSearchChanged() {
    context.read<CategoryBloc>().add(SetFilterCategory(filter: searchController.text));
  }
}
