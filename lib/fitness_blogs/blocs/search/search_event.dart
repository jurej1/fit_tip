part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryUpdated extends SearchEvent {
  final String query;

  const SearchQueryUpdated(this.query);
}

class SearchQueryClerRequested extends SearchEvent {}
