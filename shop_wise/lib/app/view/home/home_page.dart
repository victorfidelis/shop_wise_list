
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_event.dart';
import 'package:shop_wise/app/bloc/page_view/page_state.dart';
import 'package:shop_wise/app/constants/page_item_navigator.dart';
import 'package:shop_wise/app/view/dialog/dialog_functions.dart';
import 'package:shop_wise/app/view/home/widgets/button_menu_format.dart';
import 'package:shop_wise/app/view/list/list_page.dart';
import 'package:shop_wise/app/view/register/register_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DialogFunctions dialogFunctions = DialogFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: context.read<PageBloc>().state.pageController,
        children: [
          ListPage(),
          RegisterPage(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          return BottomAppBar(
            color: Theme.of(context).colorScheme.secondary,
            shape: CircularNotchedRectangle(),
            child: Row(
              children: [
                Expanded(
                  child: ButtonMenuFormat(
                    onPressed: () {
                      context.read<PageBloc>().add(PageNavigated(page: PageItemNavigator.list));
                    },
                    icon: Icons.grid_view,
                    text: 'Listas',
                    isCurrent: PageItemNavigator.list == state.currentPage,
                  ),
                ),
                Expanded(
                  child: ButtonMenuFormat(
                    onPressed: () {
                      context
                          .read<PageBloc>()
                          .add(PageNavigated(page: PageItemNavigator.register));
                    },
                    icon: Icons.list_alt_sharp,
                    text: 'Cadastros',
                    isCurrent: PageItemNavigator.register == state.currentPage,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
