import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_event.dart';
import 'package:shop_wise/app/bloc/list/list_bloc.dart';
import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/bloc/list/list_state.dart';
import 'package:shop_wise/app/models/button_dialog/button_dialog_model.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/list/edit_list_page.dart';
import 'package:shop_wise/app/view/list/widgets/list_tile_format.dart';
import 'package:shop_wise/app/view/product_list/product_list_page.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/menu_button_dialog.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with WidgetsBindingObserver {
  static const platform = const MethodChannel("br.com.vfdesenvolvimento.shop_wise_list/file");

  DialogFunctions dialogFunctions = DialogFunctions();

  bool close = false;

  @override
  void initState() {
    super.initState();
    context.read<ListBloc>().add(const ListStarted());
    getOpenFileUrl();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void getOpenFileUrl() async {
    String? url = await platform.invokeMethod("getOpenFileUrl");
    if (url != null) {
      Uri uri = Uri.parse(url);
      File file = await toFile(uri.toString());
      _alertImport(file);
    }
  }

  void _alertImport(File file) {
    AlertDialog alert = AlertDialog(
      title: Text('Importação de lista'),
      content: Text('Deseja realizar a importação de lista através do arquivo selecionado?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ListBloc>().add(ListImported(file: file));
          },
          child: Text('Sim', style: TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Não', style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  // void _alertImportText() {
  //   String jsonText = '{"list":{"id":4,"date":1719086095145,"store":{"id":7,"name":"Extra Shopping Campo Limpo"},"value":84.72999999999999},"items":[{"id":4,"product":{"id":19,"categoryId":null,"categoryName":"","name":"Margarina Qualy"},"price":5.99,"quantity":1.0,"total":5.99,"check":true},{"id":5,"product":{"id":20,"categoryId":null,"categoryName":"","name":"Pipoca 🍿"},"price":7.99,"quantity":1.0,"total":7.99,"check":true},{"id":6,"product":{"id":26,"categoryId":null,"categoryName":"","name":"Maionese 500g"},"price":10.79,"quantity":1.0,"total":10.79,"check":true},{"id":7,"product":{"id":22,"categoryId":null,"categoryName":"","name":"Batata palha"},"price":7.99,"quantity":1.0,"total":7.99,"check":true},{"id":8,"product":{"id":23,"categoryId":null,"categoryName":"","name":"Leite Integral 🥛"},"price":5.39,"quantity":2.0,"total":10.78,"check":true},{"id":9,"product":{"id":24,"categoryId":null,"categoryName":"","name":"Fanta Uva"},"price":9.59,"quantity":1.0,"total":9.59,"check":true},{"id":10,"product":{"id":27,"categoryId":null,"categoryName":"","name":"Salsicha"},"price":9.9,"quantity":0.608,"total":6.02,"check":true},{"id":11,"product":{"id":28,"categoryId":null,"categoryName":"","name":"Achocolatado Toddy 370g"},"price":9.49,"quantity":1.0,"total":9.49,"check":true},{"id":12,"product":{"id":29,"categoryId":null,"categoryName":"","name":"Milho verde 🌽"},"price":4.19,"quantity":1.0,"total":4.19,"check":true},{"id":13,"product":{"id":30,"categoryId":null,"categoryName":"","name":"Nuggets"},"price":11.9,"quantity":1.0,"total":11.9,"check":true},{"id":14,"product":{"id":17,"categoryId":1,"categoryName":"Frutas","name":"Maça"},"price":0.0,"quantity":8.0,"total":0.0,"check":false},{"id":15,"product":{"id":31,"categoryId":1,"categoryName":"Frutas","name":"Banana"},"price":0.0,"quantity":12.0,"total":0.0,"check":false},{"id":16,"product":{"id":32,"categoryId":1,"categoryName":"Frutas","name":"Pera"},"price":0.0,"quantity":5.0,"total":0.0,"check":false},{"id":17,"product":{"id":33,"categoryId":1,"categoryName":"Frutas","name":"Uva"},"price":0.0,"quantity":0.5,"total":0.0,"check":false},{"id":18,"product":{"id":34,"categoryId":2,"categoryName":"Açougue","name":"Contra-filé"},"price":0.0,"quantity":1.5,"total":0.0,"check":true},{"id":19,"product":{"id":35,"categoryId":2,"categoryName":"Açougue","name":"Acém"},"price":0.0,"quantity":0.0,"total":0.0,"check":true},{"id":20,"product":{"id":36,"categoryId":2,"categoryName":"Açougue","name":"Peito de frango"},"price":0.0,"quantity":3.0,"total":0.0,"check":true},{"id":21,"product":{"id":37,"categoryId":1,"categoryName":"Frutas","name":"Manga"},"price":0.0,"quantity":2.0,"total":0.0,"check":false},{"id":22,"product":{"id":38,"categoryId":null,"categoryName":"","name":"Cuscuz"},"price":0.0,"quantity":0.0,"total":0.0,"check":false}]}';
  //   AlertDialog alert = AlertDialog(
  //     title: Text('Importação de lista'),
  //     content: Text('Deseja realizar a importação de lista através do arquivo selecionado?'),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //           context.read<ListBloc>().add(ListImportedText(text: jsonText));
  //         },
  //         child: Text('Sim', style: TextStyle(color: Colors.green)),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: Text('Não', style: TextStyle(color: Colors.red)),
  //       ),
  //     ],
  //   );
  //
  //   showDialog(context: context, builder: (context) => alert);
  // }

  @override
  Widget build(BuildContext context) {

    // Future.delayed(Duration(seconds: 3)).then(
    //     (value) {
    //       _alertImportText();
    //     }
    // );

    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (close) {
          close = false;
          SystemNavigator.pop();
        } else {
          close = true;
          Future.delayed(Duration(seconds: 2)).then((value) {
            close = false;
          });
          dialogFunctions.showSnackBar(
            context: context,
            message: 'Clique novamente para sair',
            duration: Duration(seconds: 2),
          );
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
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            opacity: 0.8,
                            image: AssetImage(
                              'assets/images/background_12.jpg',
                            ),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  'Minhas listas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<ListBloc, ListState>(
                      listener: (context, state) {
                        if (state is ListMessage) {
                          dialogFunctions.showSnackBar(context: context, message: state.message);
                        }

                        if (state is ListPickedSuccess) {
                          _alertImport(state.importedFile);
                        }
                      },
                      builder: (context, state) {
                        if (state is ListLoading) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is ListFailure) {
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

                        if (state.lists.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Nenhuma lista cadastrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount: state.lists.length + 2,
                            itemBuilder: (context, index) {
                              if (index >= state.lists.length) return SizedBox(height: 18);
                              return ListTileFormat(
                                list: state.lists[index],
                                onTap: () {
                                  _onTapList(state.lists[index]);
                                },
                                onLongPress: () {
                                  _onLongPressList(state.lists[index]);
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
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonFormat(
              onPressed: () {
                context.read<ListBloc>().add(ListPicked());
              },
              text: 'Importar',
              icon: Icons.import_export,
            ),
            SizedBox(width: 10),
            ButtonFormat(
              onPressed: _goToEditList,
              text: 'Criar nova lista',
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  void _goToEditList({ListModel? list}) {
    context.read<EditListBloc>().add(EditListStarted(list: list));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditListPage(list: list);
    }));
  }

  void _onTapList(ListModel list) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductListPage(list: list);
        },
      ),
    );
  }

  void _onLongPressList(ListModel list) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuButtonDialog(
          buttons: [
            ButtonDialogModel(
              text: 'Abrir',
              onPressed: () {
                Navigator.pop(context);
                _onTapList(list);
              },
              icon: Icons.file_open,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Editar',
              onPressed: () {
                Navigator.pop(context);
                _goToEditList(list: list);
              },
              icon: Icons.edit,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Replicar',
              onPressed: () {
                Navigator.pop(context);
                _onListReplicate(list: list);
              },
              icon: Icons.copy_all,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            ButtonDialogModel(
              text: 'Excluir',
              onPressed: () {
                Navigator.pop(context);
                _onListDeleted(list);
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
            ),
          ],
        );
      },
    );
  }

  void _onListDeleted(ListModel list) {
    AlertDialog alert = AlertDialog(
      title: Text('Exclusão de lista'),
      content: Text(
        'Tem certeza que deseja excluir a lista da loja "${list.store.name}"?\n'
        'Ao continuar todos os itens serão cancelados e a operação não poderá ser desfeita.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ListBloc>().add(ListDeleted(list: list));
          },
          child: Text(
            'Excluir',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  void _onListReplicate({required ListModel list}) {
    Widget alert = AlertDialog(
      title: Text(
        'Selecione quais itens deverão ser replicados para a nova lista',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButtonDialog(
            backgroundColor: Colors.transparent,
            buttons: [
              ButtonDialogModel(
                text: 'Todos os itens',
                onPressed: () {
                  context.read<ListBloc>().add(
                        ListReplicated(
                          list: list,
                          listReplicateType: ListReplicateType.all,
                        ),
                      );
                  Navigator.pop(context);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Apenas itens marcados',
                onPressed: () {
                  context.read<ListBloc>().add(
                        ListReplicated(
                          list: list,
                          listReplicateType: ListReplicateType.checked,
                        ),
                      );
                  Navigator.pop(context);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              ButtonDialogModel(
                text: 'Apenas itens desmarcados',
                onPressed: () {
                  context.read<ListBloc>().add(
                        ListReplicated(
                          list: list,
                          listReplicateType: ListReplicateType.unchecked,
                        ),
                      );
                  Navigator.pop(context);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
