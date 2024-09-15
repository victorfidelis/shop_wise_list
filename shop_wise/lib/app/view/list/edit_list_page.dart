import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_event.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_state.dart';
import 'package:shop_wise/app/bloc/list/list_bloc.dart';
import 'package:shop_wise/app/bloc/list/list_event.dart';
import 'package:shop_wise/app/bloc/mold/mold_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_event.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/models/store/store_model.dart';
import 'package:shop_wise/app/view/list/mold_select_page.dart';
import 'package:shop_wise/app/view/list/widgets/text_field_mold_format.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/suggestion_card.dart';
import 'package:shop_wise/app/view/widget/text_field_date_format.dart';
import 'package:intl/intl.dart';

class EditListPage extends StatefulWidget {
  const EditListPage({
    super.key,
    this.list,
  });

  final ListModel? list;

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController moldController = TextEditingController();

  String? dateError;
  bool changeList = false;

  @override
  void initState() {
    changeList = widget.list == null ? false : true;

    if (changeList) {
      nameController.text = widget.list!.store.name;

      DateTime date = widget.list!.date == null ? DateTime.now() : widget.list!.date!;
      dateController.text = DateFormat('dd/MM/yyyy').format(date);
      context.read<EditListBloc>().add(EditListDateDefined(date: date));
    } else {
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      context.read<EditListBloc>().add(EditListDateDefined(date: DateTime.now()));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 58),
                      child: Text(
                        widget.list?.store.name ?? 'Nova lista',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 4, top: 30),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocConsumer<EditListBloc, EditListState>(listener: (context, state) {
                if (state.saveList) _saveList();
              }, builder: (context, state) {
                if (state.list.store.id != null) nameController.text = state.list.store.name;

                if (state.status == EditListStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                moldController.text =
                    state.mold.name.isEmpty ? 'Nenhum modelo selecionado' : state.mold.name;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        context.read<EditListBloc>().add(EditListSearched(text: value));
                      },
                      decoration: InputDecoration(
                        label: const Text('Loja'),
                        errorText: state.nameError.isEmpty ? null : state.nameError,
                        suffix: state.list.store.id == null
                            ? null
                            : Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: state.storesTips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<EditListBloc>()
                                  .add(EditListSelected(store: state.storesTips[index]));
                            },
                            child: SuggestionCard(
                              suggestion: state.storesTips[index].name,
                              hasDivider: index < (state.storesTips.length - 1),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFieldDateFormat(
                      controller: dateController,
                      label: 'Data',
                      onSet: _onSetDate,
                    ),
                    changeList ? Container() : SizedBox(height: 24),
                    changeList
                        ? Container()
                        : TextFieldMoldFormat(
                            onTap: _goToSelectMold,
                            controller: moldController,
                            selected: state.mold.name.isNotEmpty,
                          ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonFormat(
        onPressed: _onSaveList,
        text: 'Salvar',
        icon: Icons.save,
      ),
    );
  }

  void _onSaveList() async {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      context.read<EditListBloc>().add(EditListValidated(
            nameError: 'Necessário informar a loja',
          ));
      return;
    }

    if (context.read<EditListBloc>().state.list.store.id == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Loja não cadastrada'),
              content: Text('Identificado que a loja digitada não existe em seu cadastro de lojas, '
                  'e para continuar será necessário o seu cadastro.'
                  '\nDeseja criá-la?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _saveStore(StoreModel(name: name));
                  },
                  child: Text('Sim'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Não'),
                ),
              ],
            );
          });
    } else {
      _saveList();
    }
  }

  void _saveStore(StoreModel store) {
    context.read<EditListBloc>().add(StoreInserted(
          store: store,
        ));
  }

  void _saveList() {
    ListModel list = context.read<EditListBloc>().state.list;
    MoldModel mold = context.read<EditListBloc>().state.mold;

    if (changeList)
      context.read<ListBloc>().add(ListUpdated(list: list));
    else
      context.read<ListBloc>().add(ListInserted(list: list, mold: mold));

    Navigator.pop(context);
  }

  void _onSetDate(DateTime? date) {
    context.read<EditListBloc>().add(EditListDateDefined(date: date));
  }

  void _goToSelectMold() {
    MoldModel mold = context.read<EditListBloc>().state.mold;
    context.read<MoldBloc>().add(MoldStarted(mold: mold));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MoldSelectPage();
    }));
  }
}
