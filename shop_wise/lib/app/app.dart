import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/category/category_bloc.dart';
import 'package:shop_wise/app/bloc/edit_list/edit_list_bloc.dart';
import 'package:shop_wise/app/bloc/list/list_bloc.dart';
import 'package:shop_wise/app/bloc/mold/mold_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_bloc.dart';
import 'package:shop_wise/app/bloc/product/product_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_bloc.dart';
import 'package:shop_wise/app/bloc/store/store_bloc.dart';
import 'package:shop_wise/app/view/home/home_page.dart';
import 'package:shop_wise/app/view/splash/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PageBloc()),
        BlocProvider(create: (_) => ListBloc()),
        BlocProvider(create: (_) => EditListBloc()),
        BlocProvider(create: (_) => StoreBloc()),
        BlocProvider(create: (_) => CategoryBloc()),
        BlocProvider(create: (_) => ProductBloc()),
        BlocProvider(create: (_) => ProductListBloc()),
        BlocProvider(create: (_) => MoldBloc()),
        BlocProvider(create: (_) => ProductMoldBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            background: Color(0xffF1FADA),
            primary: Color(0xff213555),
            secondary: Colors.black87,
            onSecondary: Colors.white12,
            tertiary: Color(0xf02D9596),
            onTertiary: Colors.black12,
            shadow: Color(0xffc0c0c0),
            tertiaryContainer: Color(0xff54504c),
          ),
        ),
        home: const SplashPage(),
        //home: const HomePage(),
      ),
    );
  }
}
