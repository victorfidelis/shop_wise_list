import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_bloc.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_event.dart';
import 'package:shop_wise/app/bloc/product_mold/product_mold_state.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_mold/product_mold_model.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/suggestion_card.dart';

class EditProductMoldPage extends StatefulWidget {
  const EditProductMoldPage({super.key,});

  @override
  State<EditProductMoldPage> createState() => _EditProductMoldPageState();
}

class _EditProductMoldPageState extends State<EditProductMoldPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  FocusNode _textNode = FocusNode();

  @override
  void initState() {
    _textNode.requestFocus();
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
                color: Theme
                    .of(context)
                    .colorScheme
                    .tertiary,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 58),
                      child: Text(
                        'Adicionar produto',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .background,
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<ProductMoldBloc, ProductMoldState>(builder: (context, state) {
                if (state.product.id != null) {
                  nameController.text = state.product.name;
                }

                categoryController.text = state.category.name;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      focusNode: _textNode,
                      controller: nameController,
                      onChanged: (value) {
                        context.read<ProductMoldBloc>().add(ProductSearched(text: value));
                      },
                      decoration: InputDecoration(
                        label: const Text('Produto'),
                        border: OutlineInputBorder(),
                        errorText: state.nameError.isEmpty ? null : state.nameError,
                        suffix: state.product.id == null
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
                        itemCount: state.productsTips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<ProductMoldBloc>()
                                  .add(ProductTipSelected(product: state.productsTips[index]));
                            },
                            child: SuggestionCard(
                              suggestion: state.productsTips[index].name,
                              hasDivider: index < (state.productsTips.length - 1),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 22),
                    TextField(
                      controller: categoryController,
                      onChanged: (value) {
                        context.read<ProductMoldBloc>().add(CategorySearched(text: value));
                      },
                      decoration: InputDecoration(
                        label: const Text('Categoria'),
                        border: OutlineInputBorder(),
                        suffix: state.category.id == null
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onTertiary,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: state.categoriesTips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<ProductMoldBloc>()
                                  .add(CategorySelected(category: state.categoriesTips[index]));
                            },
                            child: SuggestionCard(
                              suggestion: state.categoriesTips[index].name,
                              hasDivider: index < (state.categoriesTips.length - 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonFormat(
        onPressed: _onSave,
        text: 'Salvar',
        icon: Icons.save,
      ),
    );
  }

  void _onSave() async {
    if (nameController.text.isEmpty) {
      context.read<ProductMoldBloc>().add(
        NameValidated(nameError: 'Necessário informar o nome do produto'),
      );
      return;
    }

    _saveProduct();
  }

  void _saveProduct() {

    ProductModel product = ProductModel(
      id: context.read<ProductMoldBloc>().state.product.id,
      name: nameController.text.trim(),
      category: context.read<ProductMoldBloc>().state.category,
    );

    String categoryName = categoryController.text.trim();

    if (context.read<ProductMoldBloc>().state.category.id == null &&
        categoryName.isNotEmpty) {
      product.copyWith(category: CategoryModel(name: categoryName));
    }

    context.read<ProductMoldBloc>().add(
      ProductMoldInserted(
        productMold: ProductMoldModel(product: product),
      ),
    );

    Navigator.pop(context);
  }
}
