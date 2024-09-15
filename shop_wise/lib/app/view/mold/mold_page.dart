import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_event.dart';
import 'package:shop_wise/app/bloc/mold/mold_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/mold/widgets/mold_tile_format.dart';
import 'package:shop_wise/app/view/product_mold/product_mold_page.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class MoldPage extends StatefulWidget {
  const MoldPage({super.key});

  @override
  State<MoldPage> createState() => _MoldPageState();
}

class _MoldPageState extends State<MoldPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<MoldBloc>().add(MoldStarted());
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
                            'Meus modelos',
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
                            hintText: 'Filtre pelo nome do modelo',
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<MoldBloc, MoldState>(
                      listener: (context, state) {
                        if (state.deletedMold != null) {
                          dialogFunctions.showSnackBar(
                              context: context,
                              message: 'Modelo "${state.deletedMold!.name}" excluído',
                              undoLabel: 'DESFAZER',
                              undoAction: () {
                                context.read<MoldBloc>().add(MoldInserted(mold: state.deletedMold!));
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state.status == MoldStatus.initial ||
                            state.status == MoldStatus.loading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.status == MoldStatus.failure) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Ocorreu uma falha na consulta dos modelos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state.molds.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhum modelo cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        int length = state.isFilter ? state.filteredMolds.length : state.molds.length;

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverList.builder(
                            itemCount: length + 1,
                            itemBuilder: (context, index) {
                              if (index >= length) return SizedBox(height: 90);

                              MoldModel mold =
                                  state.isFilter ? state.filteredMolds[index] : state.molds[index];

                              return MoldTileFormat(
                                  mold: mold,
                                  onTap: () {
                                    _onTapMold(mold);
                                  },
                                  onLongPress: () {
                                    _onLongPressMold(mold);
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
          onPressed: _goToEditMold,
          text: 'Criar novo modelo',
          icon: Icons.add,
        ),
      ),
    );
  }

  void _goToEditMold({MoldModel? mold}) {
    bool isChange = mold != null;
    String moldName = '';
    TextEditingController nameController = TextEditingController();

    nameController.text = mold?.name ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mold?.name ?? 'Novo modelo'),
          content: TextField(
            controller: nameController,
            onChanged: (value) {
              moldName = value;
            },
          ),
          actions: [
            ButtonFormat(
              onPressed: () {
                if (moldName.isEmpty) return;

                if (isChange) {
                  context.read<MoldBloc>().add(
                        MoldUpdated(
                          mold: mold.copyWith(name: moldName),
                        ),
                      );
                } else {
                  context.read<MoldBloc>().add(
                        MoldInserted(
                          mold: MoldModel(name: moldName),
                        ),
                      );
                }
                Navigator.pop(context);
              },
              text: 'Salvar modelo',
              icon: Icons.save,
            ),
          ],
        );
      },
    );
  }

  void _onTapMold(MoldModel mold) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProductMoldPage(mold: mold);
    }));
  }

  void _onLongPressMold(MoldModel mold) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuButtonDialog(
          buttons: [
            ButtonDialogModel(
              text: 'Abrir',
              onPressed: () {
                Navigator.pop(context);
                _onTapMold(mold);
              },
              icon: Icons.file_open,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Editar',
              onPressed: () {
                Navigator.pop(context);
                _goToEditMold(mold: mold);
              },
              icon: Icons.edit,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Excluir',
              onPressed: () {
                Navigator.pop(context);
                context.read<MoldBloc>().add(MoldDeleted(mold: mold));
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
    context.read<MoldBloc>().add(SetFilterMold(filter: searchController.text));
  }
}
