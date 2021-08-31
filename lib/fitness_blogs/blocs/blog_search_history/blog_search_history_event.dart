part of 'blog_search_history_bloc.dart';

abstract class BlogSearchHistoryEvent extends Equatable {
  const BlogSearchHistoryEvent();

  @override
  List<Object> get props => [];
}

class BlogSearchHistoryItemAdded extends BlogSearchHistoryEvent {
  final String value;
  final SearchBy searchBy;

  const BlogSearchHistoryItemAdded({
    required this.value,
    required this.searchBy,
  });

  @override
  List<Object> get props => [value, searchBy];
}
