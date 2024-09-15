import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_event.dart';
import 'package:shop_wise/app/bloc/mold/mold_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_event.dart';
import 'package:shop_wise/app/bloc/mold/mold_state.dart';
import 'package:shop_wise/app/models/mold/mold_model.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/mold/widgets/mold_tile_format.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/search_component.dart';

class MoldSelectPage extends StatefulWidget {
  const MoldSelectPage({super.key});

  @override
  State<MoldSelectPage> createState() => _MoldSelectPageState();
}

class _MoldSelectPageState extends State<MoldSelectPage> {
  DialogFunctions dialogFunctions = DialogFunctions();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Selecione um modelo',
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
                  BlocBuilder<MoldBloc, MoldState>(
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
                            child: Text('Ocorreu uma falha na consulta dos modelos'),
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
        onPressed: _onSave,
        text: 'Selecionar',
        icon: Icons.save,
      ),
    );
  }

  void _onTapMold(MoldModel mold) {
    context.read<MoldBloc>().add(MoldSelected(mold: mold));
  }

  void _onSave() {
    MoldModel mold = context.read<MoldBloc>().state.selectedMold;
    context.read<EditListBloc>().add(SelectedMold(mold: mold));
    Navigator.pop(context);
  }

  void _onSearchChanged() {
    context.read<MoldBloc>().add(SetFilterMold(filter: searchController.text));
  }
}
