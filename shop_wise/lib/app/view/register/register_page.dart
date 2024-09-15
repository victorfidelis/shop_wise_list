import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_event.dart';
import 'package:shop_wise/app/constants/page_item_navigator.dart';
import 'package:shop_wise/app/models/list/list_model.dart';
import 'package:shop_wise/app/view/category/category_page.dart';
import 'package:shop_wise/app/view/mold/mold_page.dart';
import 'package:shop_wise/app/view/product/product_page.dart';
import 'package:shop_wise/app/view/register/widgets/register_card_format.dart';
import 'package:shop_wise/app/view/store/store_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    super.key,
    this.list,
  });

  ListModel? list;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        context.read<PageBloc>().add(PageNavigated(page: PageItemNavigator.list));
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                image: DecorationImage(
                  image: AssetImage('assets/images/background_00.jpg'),
                  fit: BoxFit.fitWidth,
                  opacity: 0.8
                ),
              ),
              child: Stack(children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 58),
                    child: Text(
                      'Cadastros',
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
              ]),
            ),
            SizedBox(height: 18),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RegisterCardFormat(
                      icon: Icons.store,
                      text: 'Lojas',
                      image: AssetImage('assets/images/store_03.jpg'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return StorePage();
                        }));
                      },
                    ),
                    SizedBox(height: 14),
                    RegisterCardFormat(
                      icon: Icons.category,
                      text: 'Categorias',
                      image: AssetImage('assets/images/category_01.jpg'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CategoryPage();
                        }));
                      },
                    ),
                    SizedBox(height: 14),
                    RegisterCardFormat(
                      icon: Icons.shopping_basket,
                      text: 'Produtos',
                      image: AssetImage('assets/images/product_01.jpg'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductPage();
                        }));
                      },
                    ),
                    SizedBox(height: 14),
                    RegisterCardFormat(
                      icon: Icons.perm_data_setting_outlined,
                      text: 'Listas modelo',
                      image: AssetImage('assets/images/mold_02.jpg'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return MoldPage();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
