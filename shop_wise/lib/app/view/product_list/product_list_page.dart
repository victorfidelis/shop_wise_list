import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/bloc/history/history_bloc.dart';
import 'package:shop_wise/app/bloc/list/list_bloc.dart';
import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_event.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/category_list/category_list_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/history/history_page.dart';
import 'package:shop_wise/app/view/product_list/edit_product_list_page.dart';
import 'package:shop_wise/app/view/product_list/widgets/category_list_tile.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, required this.list});

  final ListModel list;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();
  final MenuController _menuController = MenuController();
  final GlobalKey<State<PopScope>> popKey = GlobalKey<State<PopScope>>();
  final ScrollController scrollController = ScrollController();
  double position = 0;

  @override
  void initState() {
    position = 0;
    context.read<ProductListBloc>().add(ProductListStarted(list: widget.list));
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

        double total = context.read<ProductListBloc>().state.totalShop;
        ListModel list = widget.list.copyWith(value: total);
        context.read<ListBloc>().add(SetCurrentList(list: list));
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 120,
                      actions: [
                        MenuAnchor(
                          controller: _menuController,
                          menuChildren: [
                            SubmenuButton(
                              menuChildren: [
                                MenuItemButton(
                                  onPressed: () {
                                    context.read<ProductListBloc>().add(ListExported());
                                  },
                                  child: Text('Arquivo de importação'),
                                ),
                                MenuItemButton(
                                  onPressed: _sharedText,
                                  child: Text('Como texto'),
                                ),
                              ],
                              child: Text('Compartilhar'),
                            ),
                            SubmenuButton(
                              menuChildren: [
                                MenuItemButton(
                                  onPressed: () {
                                    context
                                        .read<ProductListBloc>()
                                        .add(SetOrder(order: ProductListOrder.check));
                                  },
                                  child: Text('Itens marcados'),
                                ),
                                MenuItemButton(
                                  onPressed: () {
                                    context
                                        .read<ProductListBloc>()
                                        .add(SetOrder(order: ProductListOrder.product));
                                  },
                                  child: Text('Nome'),
                                ),
                                MenuItemButton(
                                  onPressed: () {
                                    context
                                        .read<ProductListBloc>()
                                        .add(SetOrder(order: ProductListOrder.quantity));
                                  },
                                  child: Text('Quantidade'),
                                ),
                                MenuItemButton(
                                  onPressed: () {
                                    context
                                        .read<ProductListBloc>()
                                        .add(SetOrder(order: ProductListOrder.price));
                                  },
                                  child: Text('Preço'),
                                ),
                                MenuItemButton(
                                  onPressed: () {
                                    context
                                        .read<ProductListBloc>()
                                        .add(SetOrder(order: ProductListOrder.total));
                                  },
                                  child: Text('Total'),
                                ),
                              ],
                              child: Text('Ordenar'),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                context
                                    .read<ProductListBloc>()
                                    .add(EncapsulateCategory());
                              },
                              child: Text('Encapsular categorias'),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                context
                                    .read<ProductListBloc>()
                                    .add(ExpandCategory());
                              },
                              child: Text('Expandir categorias'),
                            ),
                          ],
                          child: IconButton(
                            onPressed: () => _menuController.open(),
                            icon: Icon(Icons.more_vert, color: Colors.white),
                          ),
                        ),
                      ],
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                SizedBox(width: 60),
                                Expanded(
                                  child: Text(
                                    widget.list.store.name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 120,
                                  child: BlocBuilder<ProductListBloc, ProductListState>(
                                    builder: (context, state) {
                                      if (state.status == ProductListStatus.initial ||
                                          state.status == ProductListStatus.loading) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (state.status == ProductListStatus.failure) {
                                        return Center(
                                          child: Text('Falha'),
                                        );
                                      }

                                      final NumberFormat priceFormat =
                                          NumberFormat("###,###,##0.00", 'pt_BR');
                                      final String totalShop = priceFormat.format(state.totalShop);
                                      final String quantityShop = state.quantityShop.toString();
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                r'R$',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                totalShop,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                quantityShop,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                ' itens',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
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
                            hintText: 'Filtre pelo nome do produto',
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<ProductListBloc, ProductListState>(
                      listener: (context, state) {
                        if (state.deletedProductList != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message:
                                  'Produto "${state.deletedProductList!.product.name}" excluído',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context.read<ProductListBloc>().add(
                                    ProductListInserted(productList: state.deletedProductList!));
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == ProductListStatus.initial ||
                            state.status == ProductListStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == ProductListStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta das listas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state.items.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhum item cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (position > 0) {
                          repositionList();
                        }

                        List<CategoryListModel> categories =
                            (state.isFilter ? state.filteredCategories : state.categories);

                        return SliverPadding(
                          padding: EdgeInsets.only(
                            left: 4,
                            top: 8,
                            right: 4,
                            bottom: 0,
                          ),
                          sliver: SliverList.builder(
                            itemCount: categories.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= categories.length) return SizedBox(height: 90);

                              List<ProductListModel> productList = [];

                              if (state.isFilter) {
                                productList = state.filteredItems
                                    .where((e) =>
                                        (e.product.category?.id ?? 0) ==
                                        (categories[index].category.id ?? 0))
                                    .toList();
                              } else {
                                productList = state.items
                                    .where((e) =>
                                        (e.product.category?.id ?? 0) ==
                                        (categories[index].category.id ?? 0))
                                    .toList();
                              }

                              return CategoryListTile(
                                categoryList: categories[index],
                                productsLists: productList,
                                onTap: _onTapItem,
                                onLongPress: _onLongPressItem,
                                hasDivider: true,
                              );
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
          onPressed: _addNewItem,
          text: 'Adicionar um item',
          icon: Icons.add,
        ),
      ),
    );
  }

  void repositionList() {
    scrollController.jumpTo(position);
  }

  void _addNewItem() {
    context.read<ProductListBloc>().add(NewItem());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EditProductListPage();
        },
      ),
    );
  }

  void _onTapItem({required ProductListModel productList}) {
    position = scrollController.position.pixels;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EditProductListPage(productList: productList);
        },
      ),
    );
  }

  void _onLongPressItem({required ProductListModel productList}) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuButtonDialog(
          buttons: [
            ButtonDialogModel(
              text: 'Editar',
              onPressed: () {
                Navigator.pop(context);
                _onTapItem(productList: productList);
              },
              icon: Icons.edit,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Últimas compras',
              onPressed: () {
                Navigator.pop(context);
                _onGetHistoryProduct(productList.product);
              },
              icon: Icons.history,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Excluir',
              onPressed: () {
                Navigator.pop(context);
                context.read<ProductListBloc>().add(ItemDeleted(productList: productList));
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
            ),
          ],
        );
      },
    );
  }

  void _onSearchChanged() {
    position = 0;
    context.read<ProductListBloc>().add(SetFilter(filter: searchController.text));
  }

  void _onGetHistoryProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return BlocProvider(
          create: (_) => HistoryBloc(),
          child: HistoryPage(product: product),
        );
      }),
    );
  }

  void _sharedText() {
    Widget alert = AlertDialog(
      title: Text('Selecione um formato de lista'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButtonDialog(
            backgroundColor: Colors.transparent,
            buttons: [
              ButtonDialogModel(
                text: 'Apenas descrição',
                onPressed: () => context.read<ProductListBloc>().add(
                      ListSharedText(
                        ignoreValues: true,
                      ),
                    ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Descrição + valores',
                onPressed: () => context.read<ProductListBloc>().add(
                      ListSharedText(
                        ignoreValues: false,
                      ),
                    ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );

    showDialog(context: context, builder: (context) => alert);
  }
}
