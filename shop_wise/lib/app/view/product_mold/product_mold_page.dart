import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_event.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/product_mold/edit_product_mold_page.dart';
import 'package:shop_wise/app/view/product_mold/widgets/product_mold_tile_format.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class ProductMoldPage extends StatefulWidget {
  const ProductMoldPage({super.key, required this.mold});

  final MoldModel mold;

  @override
  State<ProductMoldPage> createState() => _ProductMoldPageState();
}

class _ProductMoldPageState extends State<ProductMoldPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ProductMoldBloc>().add(ProductMoldStarted(mold: widget.mold));
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                SizedBox(width: 60),
                                Expanded(
                                  child: Text(
                                    widget.mold.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 40),
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
                    BlocConsumer<ProductMoldBloc, ProductMoldState>(
                      listener: (context, state) {
                        if (state.deletedProductMold != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message: 'Produto "${state.deletedProductMold!.product.name}" excluído',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context.read<ProductMoldBloc>().add(
                                      ProductMoldInserted(
                                        productMold: state.deletedProductMold!,
                                      ),
                                    );
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == ProductMoldStatus.initial ||
                            state.status == ProductMoldStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == ProductMoldStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta dos produtos',
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

                        int length = state.isFilter ? state.filteredItems.length : state.items.length;

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverList.builder(
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index >= length) return SizedBox(height: 90);

                              ProductMoldModel productMold =
                                  state.isFilter ? state.filteredItems[index] : state.items[index];

                              return ProductMoldTileFormat(
                                  productMold: productMold,
                                  onLongPress: () {
                                    _onLongPressMold(productMold);
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
          onPressed: _addNewItem,
          text: 'Criar novo produto',
          icon: Icons.add,
        ),
      ),
    );
  }

  void _addNewItem() {
    context.read<ProductMoldBloc>().add(NewItem());

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditProductMoldPage();
    }));

  }

  void _onLongPressMold(ProductMoldModel productMold) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuButtonDialog(
          buttons: [
            ButtonDialogModel(
              text: 'Excluir',
              onPressed: () {
                Navigator.pop(context);
                context.read<ProductMoldBloc>().add(ItemDeleted(productMold: productMold));
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
    context.read<ProductMoldBloc>().add(SetFilter(filter: searchController.text));
  }
}
