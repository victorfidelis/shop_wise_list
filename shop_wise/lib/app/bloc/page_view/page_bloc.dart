import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_wise/app/bloc/page_view/page_event.dart';
import 'package:shop_wise/app/bloc/page_view/page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc()
      : super(
          PageState(
            currentPage: 0,
            pageController: PageController(initialPage: 0),
          ),
        ) {
    on<PageNavigated>(_onPageNavigated);
  }

  void _onPageNavigated(PageNavigated event, Emitter emit) {
    state.pageController.jumpToPage(event.page);
    emit(state.copyWith(
      currentPage: event.page,
    ));
  }
}
