import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/history/history_bloc.dart';
import 'package:shop_wise/app/bloc/product/product_bloc.dart';
import 'package:shop_wise/app/bloc/product/product_event.dart';
import 'package:shop_wise/app/bloc/product/product_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/history/history_page.dart';
import 'package:shop_wise/app/view/product/edit_product_page.dart';
import 'package:shop_wise/app/view/product/widgets/product_tile_format.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductStarted());
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
                            'Meus produtos',
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
                            hintText: 'Filtre pelo nome do produto',
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        if (state.deletedProduct != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message: 'Produto "${state.deletedProduct!.name}" excluído',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context
                                    .read<ProductBloc>()
                                    .add(ProductInserted(product: state.deletedProduct!));
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == ProductStatus.initial ||
                            state.status == ProductStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == ProductStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta das produtos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state.products.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhum produto cadastrado',
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
                            state.isFilter ? state.filteredItems.length : state.products.length;

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverList.builder(
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index >= length) return SizedBox(height: 90);
                              ProductModel product = state.isFilter
                                  ? state.filteredItems[index]
                                  : state.products[index];
                              return ProductTileFormat(
                                product: product,
                                onTap: () {
                                  _onTapProduct(product);
                                },
                                onLongPress: () {
                                  _onLongPressProduct(product);
                                },
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
          onPressed: _goToEditProduct,
          text: 'Criar novo produto',
          icon: Icons.add,
        ),
      ),
    );
  }

  void _goToEditProduct({ProductModel? product}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProductPage(product: product);
    }));
  }

  void _onTapProduct(ProductModel product) {
    _goToEditProduct(product: product);
  }

  void _onLongPressProduct(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<ProductBloc, ProductState>(listener: (context, state) {
          if (state.status == ProductStatus.loading) return;

          if (state.deletedProductVerify != null) {
            if (state.deletePermission) {
              Navigator.pop(context);
              context.read<ProductBloc>().add(ProductDeleted(product: product));
            } else {
              AlertDialog alert = AlertDialog(
                title: Text('Exclusão negada'),
                content: Text('Produto "${state.deletedProductVerify!.name}" não pode ser excluído '
                    'pois está cadastrado em alguma lista'),
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
          if (state.status == ProductStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return MenuButtonDialog(
            buttons: [
              ButtonDialogModel(
                text: 'Editar',
                onPressed: () {
                  Navigator.pop(context);
                  _onTapProduct(product);
                },
                icon: Icons.edit,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Últimas compras',
                onPressed: () => _onGetHistoryProduct(product),
                icon: Icons.history,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Excluir',
                onPressed: () {
                  context.read<ProductBloc>().add(ProductDeleteValidated(product: product));
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

  void _onSearchChanged() {
    context.read<ProductBloc>().add(SetFilterProduct(filter: searchController.text));
  }
}
