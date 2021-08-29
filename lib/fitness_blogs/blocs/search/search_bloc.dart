import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/models/models.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchQueryUpdated) {
      yield* _mapQueryUpdatedToState(event);
    } else if (event is SearchQueryUpdated) {
      yield* _mapClearRequestedToState();
    }
  }

  Stream<SearchState> _mapQueryUpdatedToState(SearchQueryUpdated event) async* {
    final search = Search.dirty(event.query);

    yield SearchState(search: search);
  }

  Stream<SearchState> _mapClearRequestedToState() async* {
    final currentQuery = state.search.value;

    if (currentQuery.isNotEmpty) {
      yield SearchState();
    }
  }
}
