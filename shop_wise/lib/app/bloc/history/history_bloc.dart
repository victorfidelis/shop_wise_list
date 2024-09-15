
import 'package:bloc/bloc.dart';
import 'package:shop_wise/app/bloc/history/history_event.dart';
import 'package:shop_wise/app/bloc/history/history_state.dart';
import 'package:shop_wise/app/models/history/history_model.dart';
import 'package:shop_wise/app/repositories/product_list/product_list_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryState()) {
    on<HistoryStarted>(_onHistoryStarted);
  }

  Future<void> _onHistoryStarted(HistoryStarted event, Emitter<HistoryState> emit) async {

    emit(state.copyWith(status: HistoryStatus.loading));

    ProductListRepository data = ProductListRepository();
    List<HistoryModel> historyItems = await data.getHistory(event.product);
    data.dispose();

    emit(
      state.copyWith(
       status: HistoryStatus.success,
       historyItems: historyItems,
       product: event.product,
      )
    );
  }
}
