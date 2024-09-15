import 'package:flutter/material.dart';

class PageState {
  const PageState({
    required this.currentPage,
    required this.pageController,
  });

  final int currentPage;
  final PageController pageController;

  PageState copyWith({
    int? currentPage,
    PageController? pageController,
    List<int>? stackPage,
  }) {
    return PageState(
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
    );
  }
}
