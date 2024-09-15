import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/product/product_bloc.dart';
import 'package:shop_wise/app/bloc/product/product_event.dart';
import 'package:shop_wise/app/bloc/product/product_state.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/suggestion_card.dart';

enum CalculateBy { quantity, price, total }

class EditProductPage extends StatefulWidget {
  const EditProductPage({
    super.key,
    this.product,
  });

  final ProductModel? product;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  FocusNode _textNode = FocusNode();

  bool get newProduct => widget.product == null;

  @override
  void initState() {
    context.read<ProductBloc>().add(
      CategorySelected(
        category: widget.product?.category ?? CategoryModel(name: ''),
      ),
    );

    if (newProduct) {
      _textNode.requestFocus();
    } else {
      nameController.text = widget.product!.name;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = newProduct ? 'Novo produto' : widget.product!.name;

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
                        title,
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
              child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                categoryController.text = state.category.name;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      focusNode: _textNode,
                      controller: nameController,
                      decoration: InputDecoration(
                        label: const Text('Nome do produto'),
                        border: OutlineInputBorder(),
                        errorText: state.nameError.isEmpty ? null : state.nameError,
                      ),
                    ),
                    SizedBox(height: 22),
                    TextField(
                      controller: categoryController,
                      onChanged: (value) {
                        context.read<ProductBloc>().add(CategorySearched(text: value));
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
                                  .read<ProductBloc>()
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
      context.read<ProductBloc>().add(
        NameValidated(nameError: 'Necessário informar o nome do produto'),
      );
      return;
    }

    _saveProduct();
  }

  void _saveProduct() {

    ProductModel product = ProductModel(
      id: widget.product?.id,
      name: nameController.text.trim(),
      category: context.read<ProductBloc>().state.category,
    );

    String categoryName = categoryController.text.trim();

    if (context.read<ProductBloc>().state.category.id == null &&
        categoryName.isNotEmpty) {
      product.copyWith(category: CategoryModel(name: categoryName));
    }

    if (newProduct) {
      context.read<ProductBloc>().add(
        ProductInserted(
            product: product,
        ),
      );
    } else {
      context.read<ProductBloc>().add(
        ProductUpdated(
          product: product
        ),
      );
    }

    Navigator.pop(context);
  }
}
