part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.search = const Search.pure(),
  });

  final Search search;

  bool get isQueryEmpty => search.value.isEmpty;

  @override
  List<Object> get props => [search];
}
