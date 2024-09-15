import 'package:shop_wise/app/models/history/history_model.dart';
import 'package:shop_wise/app/models/product/product_model.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.product = const ProductModel(),
    this.historyItems = const [],
  });

  final HistoryStatus status;
  final ProductModel product;
  final List<HistoryModel> historyItems;

  double get totalPrice {
    if (historyItems.isEmpty) return 0.0;

    double sumTotal = historyItems.map((e) => e.productList.total).reduce((h1, h2) => h1 + h2);
    return sumTotal;
  }

  double get averagePrice {
    if (historyItems.isEmpty) return 0.0;

    double sumPrice = historyItems.map((e) => e.productList.price).reduce((h1, h2) => h1 + h2);
    return sumPrice / historyItems.length;
  }

  HistoryState copyWith({
    HistoryStatus? status,
    ProductModel? product,
    List<HistoryModel>? historyItems,
  }) {
    return HistoryState(
      status: status ?? this.status,
      product: product ?? this.product,
      historyItems: historyItems ?? this.historyItems,
    );
  }
}
