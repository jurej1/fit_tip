part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.search = const Search.pure(),
    this.searchBy = SearchBy.title,
  });

  final Search search;
  final SearchBy searchBy;

  bool get isQueryEmpty => search.value.isEmpty;

  @override
  List<Object> get props => [search, searchBy];

  SearchState copyWith({
    Search? search,
    SearchBy? searchBy,
  }) {
    return SearchState(
      search: search ?? this.search,
      searchBy: searchBy ?? this.searchBy,
    );
  }
}
