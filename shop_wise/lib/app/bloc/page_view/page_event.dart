
sealed class PageEvent {
  const PageEvent();
}

class PageNavigated extends PageEvent {
  const PageNavigated({required this.page});

  final int page;
}
