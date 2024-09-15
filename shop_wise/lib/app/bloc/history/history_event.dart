
import 'package:shop_wise/app/models/product/product_model.dart';

sealed class HistoryEvent {
  const HistoryEvent();
}

class HistoryStarted extends HistoryEvent {
  const HistoryStarted({required this.product});

  final ProductModel product;
}