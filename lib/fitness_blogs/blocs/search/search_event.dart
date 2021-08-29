part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryUpdated extends SearchEvent {
  final String query;

  const SearchQueryUpdated(this.query);

  @override
  List<Object> get props => [query];
}

class SearchQueryClerRequested extends SearchEvent {}

class SearchByUpdated extends SearchEvent {
  final SearchBy value;

  const SearchByUpdated(this.value);
  @override
  List<Object> get props => [value];
}
