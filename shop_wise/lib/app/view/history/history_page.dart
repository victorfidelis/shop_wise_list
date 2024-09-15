import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/bloc/history/history_bloc.dart';
import 'package:shop_wise/app/bloc/history/history_event.dart';
import 'package:shop_wise/app/bloc/history/history_state.dart';
import 'package:shop_wise/app/models/product/product_model.dart';
import 'package:shop_wise/app/view/history/widgets/history_tile.dart';
import 'package:shop_wise/app/view/sliver_fixed_header_delegate/sliver_fixed_header_delegate.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<HistoryBloc>().add(HistoryStarted(product: widget.product));
    super.initState();
  }

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
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Center(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state.status != HistoryStatus.success || state.historyItems.isEmpty)
                        return SliverToBoxAdapter(child: Container());

                      final NumberFormat priceFormat = NumberFormat("###,###,##0.00", 'pt_BR');
                      final String averagePrice = priceFormat.format(state.averagePrice);

                      return SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverFixedHeaderDelegate(
                          minHeight: 64,
                          maxHeight: 64,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Preço médio: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      r'R$ ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.tertiaryContainer,
                                      ),
                                    ),
                                    Text(
                                      averagePrice,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Compras dos últimos 180 dias',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state.status == HistoryStatus.initial ||
                          state.status == HistoryStatus.loading) {
                        return SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state.status == HistoryStatus.failure) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Ocorreu uma falha na consulta das produtos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }
                      if (state.historyItems.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Produto não possui histórico de compras',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        sliver: SliverList.builder(
                          itemCount: state.historyItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index >= state.historyItems.length) return SizedBox(height: 90);
                            return HistoryTile(historyItem: state.historyItems[index]);
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
    );
  }
}
