part of 'filtered_blog_search_history_bloc.dart';

abstract class FilteredBlogSearchHistoryEvent extends Equatable {
  const FilteredBlogSearchHistoryEvent();

  @override
  List<Object> get props => [];
}

class FilteredBlogSearchHistorySearchByUpdated extends FilteredBlogSearchHistoryEvent {
  final SearchBy searchBy;

  const FilteredBlogSearchHistorySearchByUpdated(this.searchBy);

  @override
  List<Object> get props => [searchBy];
}

class FilteredBlogSearchHistoryQueryUpdated extends FilteredBlogSearchHistoryEvent {
  final String value;

  const FilteredBlogSearchHistoryQueryUpdated(this.value);

  @override
  List<Object> get props => [value];
}
