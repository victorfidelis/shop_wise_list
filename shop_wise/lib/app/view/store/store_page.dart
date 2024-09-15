import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/store/store_bloc.dart';
import 'package:shop_wise/app/bloc/store/store_event.dart';
import 'package:shop_wise/app/bloc/store/store_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/store/widgets/store_tile_format.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<StoreBloc>().add(const StoreStarted());
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
                            'Minhas lojas',
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
                            hintText: 'Filtre pelo nome da loja',
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<StoreBloc, StoreState>(
                      listener: (context, state) {
                        if (state.deletedStore != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message: 'Loja "${state.deletedStore!.name}" excluída',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context
                                    .read<StoreBloc>()
                                    .add(StoreInserted(store: state.deletedStore!));
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == StoreStatus.initial ||
                            state.status == StoreStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == StoreStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta das lojas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state.stores.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhuma loja cadastrada',
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
                            state.isFilter ? state.filteredStores.length : state.stores.length;

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverList.builder(
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index >= length) return SizedBox(height: 90);

                              StoreModel store =
                                  state.isFilter ? state.filteredStores[index] : state.stores[index];

                              return StoreTileFormat(
                                  store: store,
                                  onTap: () {
                                    _onTapStore(store);
                                  },
                                  onLongPress: () {
                                    _onLongPressStore(store);
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
          onPressed: _goToEditStore,
          text: 'Criar nova loja',
          icon: Icons.add,
        ),
      ),
    );
  }

  void _goToEditStore({StoreModel? store}) {
    bool isChange = store != null;
    String storeName = '';
    TextEditingController nameController = TextEditingController();

    nameController.text = store?.name ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(store?.name ?? 'Nova loja'),
          content: TextField(
            controller: nameController,
            onChanged: (value) {
              storeName = value;
            },
          ),
          actions: [
            ButtonFormat(
              onPressed: () {
                if (storeName.isEmpty) return;

                if (isChange) {
                  context.read<StoreBloc>().add(
                        StoreUpdated(
                          store: store.copyWith(name: storeName),
                        ),
                      );
                } else {
                  context.read<StoreBloc>().add(
                        StoreInserted(
                          store: StoreModel(name: storeName),
                        ),
                      );
                }
                Navigator.pop(context);
              },
              text: 'Salvar loja',
              icon: Icons.save,
            ),
          ],
        );
      },
    );
  }

  void _onTapStore(StoreModel store) {
    _goToEditStore(store: store);
  }

  void _onLongPressStore(StoreModel store) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<StoreBloc, StoreState>(listener: (context, state) {
          if (state.status == StoreStatus.loading) return;

          if (state.deletedStoreVerify != null) {
            if (state.deletePermission) {
              Navigator.pop(context);
              context.read<StoreBloc>().add(StoreDeleted(store: store));
            } else {
              AlertDialog alert = AlertDialog(
                title: Text('Exclusão negada'),
                content: Text('Loja "${state.deletedStoreVerify!.name}" não pode ser excluída '
                    'pois está cadastrada em alguma lista'),
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
          if (state.status == StoreStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return MenuButtonDialog(
            buttons: [
              ButtonDialogModel(
                text: 'Editar',
                onPressed: () {
                  Navigator.pop(context);
                  _onTapStore(store);
                },
                icon: Icons.edit,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Excluir',
                onPressed: () {
                  context.read<StoreBloc>().add(StoreDeleteValidated(store: store));
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
    context.read<StoreBloc>().add(SetFilterStore(filter: searchController.text));
  }
}
