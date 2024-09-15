import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_bloc.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_event.dart';
import 'package:shop_wise/app/bloc/product_list/product_list_state.dart';
import 'package:shop_wise/app/models/category/category_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/models/product_list/product_list_model.dart';
import 'package:shop_wise/app/view/product_list/widgets/text_field_number.dart';
import 'package:shop_wise/app/view/product_list/widgets/text_field_quantity.dart';
import 'package:shop_wise/app/view/widget/button_format.dart';
import 'package:shop_wise/app/view/widget/suggestion_card.dart';

enum CalculateBy { quantity, price, total }

class EditProductListPage extends StatefulWidget {
  const EditProductListPage({
    super.key,
    this.productList,
  });

  final ProductListModel? productList;

  @override
  State<EditProductListPage> createState() => _EditProductListPageState();
}

class _EditProductListPageState extends State<EditProductListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  CalculateBy calculateBy = CalculateBy.quantity;
  FocusNode _textNode = FocusNode();

  bool get newProductInList => widget.productList == null;

  @override
  void initState() {
    if (newProductInList) {
      _textNode.requestFocus();
    } else {
      loadProduct();
    }

    super.initState();
  }

  void loadProduct() {
    context.read<ProductListBloc>().add(ProductTipSelected(product: widget.productList!.product));

    nameController.text = widget.productList!.product.name;
    categoryController.text = widget.productList!.product.category?.name ?? '';

    final NumberFormat quantityFormat = NumberFormat("########0.###", 'pt_BR');
    quantityController.text = quantityFormat.format(widget.productList!.quantity);

    final NumberFormat priceFormat = NumberFormat("########0.00", 'pt_BR');
    priceController.text = priceFormat.format(widget.productList!.price);
    totalController.text = priceFormat.format(widget.productList!.total);
  }

  @override
  Widget build(BuildContext context) {
    String title = newProductInList ? 'Novo produto' : widget.productList!.product.name;

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
                        title,
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
              child: BlocBuilder<ProductListBloc, ProductListState>(builder: (context, state) {
                if (state.product.id != null) {
                  nameController.text = state.product.name;
                }
                if (state.product.category?.id != null) {
                  categoryController.text = state.product.category!.name;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      focusNode: _textNode,
                      controller: nameController,
                      onChanged: (value) {
                        context.read<ProductListBloc>().add(ProductSearched(text: value));
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
                                  .read<ProductListBloc>()
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
                        context.read<ProductListBloc>().add(CategorySearched(text: value));
                      },
                      decoration: InputDecoration(
                        label: const Text('Categoria'),
                        border: OutlineInputBorder(),
                        suffix: state.product.category?.id == null
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
                        itemCount: state.categoriesTips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<ProductListBloc>()
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
                    SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFieldQuantity(
                              controller: quantityController,
                              decimalPlaces: 3,
                              label: 'Quantidade',
                              setCalculate: () {
                                calculateBy = CalculateBy.quantity;
                              },
                              calculate: () => _calculate(),
                              addQuantity: _addQuantityAlert,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'X',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFieldNumber(
                              controller: priceController,
                              decimalPlaces: 2,
                              label: 'Preço',
                              setCalculate: () {
                                calculateBy = CalculateBy.price;
                              },
                              calculate: () => _calculate(),
                              prefix: 'R\$ ',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFieldNumber(
                              controller: totalController,
                              decimalPlaces: 2,
                              label: 'Preço total',
                              setCalculate: () {
                                calculateBy = CalculateBy.total;
                              },
                              calculate: () => _calculate(),
                              prefix: 'R\$ ',
                            ),
                          ),
                        ],
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
      context.read<ProductListBloc>().add(NameValidated(
            nameError: 'Necessário informar o produto',
          ));
      return;
    }

    _calculate();

    int? id = widget.productList?.id;
    ProductModel product = context.read<ProductListBloc>().state.product;
    double quantity = double.parse(
        quantityController.text.isEmpty ? '0' : quantityController.text.replaceAll(',', '.'));
    double price = double.parse(
        priceController.text.isEmpty ? '0' : priceController.text.replaceAll(',', '.'));
    double total = double.parse(
        totalController.text.isEmpty ? '0' : totalController.text.replaceAll(',', '.'));
    bool check = widget.productList?.check ?? false;

    String categoryName = categoryController.text.trim();

    if (product.category?.id == null && categoryName.isNotEmpty) {
      product.copyWith(category: CategoryModel(name: categoryName));
    }

    if (newProductInList) {
      context.read<ProductListBloc>().add(
            ProductListInserted(
              productList: ProductListModel(
                id: id,
                product: product,
                quantity: quantity,
                price: price,
                total: total,
                check: check,
              ),
            ),
          );
    } else {
      context.read<ProductListBloc>().add(
            ProductListUpdated(
              productList: ProductListModel(
                id: id,
                product: product,
                quantity: quantity,
                price: price,
                total: total,
                check: check,
              ),
            ),
          );
    }

    Navigator.pop(context);
  }

  void _calculate() {
    double quantity = double.parse(
        quantityController.text.isEmpty ? '0' : quantityController.text.replaceAll(',', '.'));
    double price = double.parse(
        priceController.text.isEmpty ? '0' : priceController.text.replaceAll(',', '.'));
    double total = double.parse(
        totalController.text.isEmpty ? '0' : totalController.text.replaceAll(',', '.'));

    if (calculateBy == CalculateBy.quantity) {
      if (quantity > 0 && price > 0) {
        total = quantity * price;
      } else if (quantity > 0 && total > 0) {
        price = total / quantity;
      }
    } else if (calculateBy == CalculateBy.price) {
      if (price > 0 && quantity > 0) {
        total = quantity * price;
      } else if (price > 0 && total > 0) {
        quantity = total / price;
      }
    } else if (calculateBy == CalculateBy.total) {
      if (total > 0 && quantity > 0) {
        price = total / quantity;
      } else if (total > 0 && price > 0) {
        quantity = total / price;
      }
    }

    if (calculateBy != CalculateBy.quantity) {
      final NumberFormat quantityFormat = NumberFormat("########0.###", 'pt_BR');
      quantityController.text = quantityFormat.format(quantity);
    }

    final NumberFormat priceFormat = NumberFormat("########0.00", 'pt_BR');

    if (calculateBy != CalculateBy.price) priceController.text = priceFormat.format(price);

    if (calculateBy != CalculateBy.total) totalController.text = priceFormat.format(total);
  }

  void _addQuantity(String addQuantityText) {
    calculateBy = CalculateBy.quantity;
    double quantity = double.parse(
        quantityController.text.isEmpty ? '0' : quantityController.text.replaceAll(',', '.'));

    double addQuantity =
        double.parse(addQuantityText.isEmpty ? '0' : addQuantityText.replaceAll(',', '.'));

    quantity += addQuantity;

    quantityController.text = quantityFormat.format(quantity);

    _calculate();
  }

  void _addQuantityAlert() {
    TextEditingController addQuantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar quantidade'),
          content: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state.status == ProductListStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return TextFieldNumber(
                controller: addQuantityController,
                decimalPlaces: 3,
                label: 'Quantidade',
                setCalculate: () {},
                calculate: () => _calculate(),
              );
            },
          ),
          actions: [
            ButtonFormat(
              onPressed: () {
                _addQuantity(addQuantityController.text);
                Navigator.pop(context);
              },
              text: 'Adicionar',
              icon: Icons.add,
            ),
          ],
        );
      },
    );
  }
}
