part of 'filtered_blog_search_history_bloc.dart';

class FilteredBlogSearchHistoryState extends Equatable {
  const FilteredBlogSearchHistoryState({
    required this.values,
  });

  final List<String> values;

  @override
  List<Object> get props => [values];
}
