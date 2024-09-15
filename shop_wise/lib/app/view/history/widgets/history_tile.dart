import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/models/history/history_model.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    super.key,
    required this.historyItem,
  });

  final HistoryModel historyItem;

  @override
  Widget build(BuildContext context) {
    final NumberFormat quantityFormat = NumberFormat("###,###,##0.###", 'pt_BR');
    final String quantity = quantityFormat.format(historyItem.productList.quantity);

    final NumberFormat priceFormat = NumberFormat("###,###,##0.00", 'pt_BR');
    final String price = priceFormat.format(historyItem.productList.price);

    String date = historyItem.date == null ? '' : DateFormat('dd/MM/yyyy').format(historyItem.date!);

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow, blurRadius: 4, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    historyItem.store.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Qtde: $quantity',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Preço: R\$ $price',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  date.isEmpty ? 'Sem data' : date,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
