import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_wise/app/models/list/list_model.dart';

class ListTileFormat extends StatelessWidget {
  ListTileFormat({
    super.key,
    required this.list,
    this.onLongPress,
    this.onTap,
  });

  final ListModel list;
  final Function()? onLongPress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String name = list.store.name;
    String value = list.value.toStringAsFixed(2).replaceAll('.', ',');
    String date =
        list.date == null ? '' : DateFormat('dd/MM/yyyy').format(list.date!);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 4,
              offset: Offset(0, 4)
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              name,
              maxLines: 3,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'R\$',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
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
    );
  }
}
