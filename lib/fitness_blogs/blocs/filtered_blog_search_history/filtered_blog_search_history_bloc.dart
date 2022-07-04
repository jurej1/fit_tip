import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

part 'filtered_blog_search_history_event.dart';
part 'filtered_blog_search_history_state.dart';

class FilteredBlogSearchHistoryBloc extends Bloc<FilteredBlogSearchHistoryEvent, FilteredBlogSearchHistoryState> {
  FilteredBlogSearchHistoryBloc({
    required BlogSearchHistoryBloc blogSearchHistoryBloc,
    required SearchBloc searchBloc,
  })  : _blogSearchHistoryBloc = blogSearchHistoryBloc,
        _searchBloc = searchBloc,
        super(
          FilteredBlogSearchHistoryState(
            values: blogSearchHistoryBloc.state.getValuesBySearchBy(searchBloc.state.searchBy),
          ),
        ) {
    _searchSubscription = searchBloc.stream.listen((searchState) {
      add(_FilteredBlogSearchHistoryQueryUpdated(searchState.search.value));
    });
  }

  final SearchBloc _searchBloc;
  final BlogSearchHistoryBloc _blogSearchHistoryBloc;
  late final StreamSubscription _searchSubscription;

  @override
  Future<void> close() {
    _searchSubscription.cancel();
    return super.close();
  }

  @override
  Stream<FilteredBlogSearchHistoryState> mapEventToState(
    FilteredBlogSearchHistoryEvent event,
  ) async* {
    if (event is _FilteredBlogSearchHistoryQueryUpdated) {
      yield* _mapQueryUpdatedToState(event);
    } else if (event is FilteredBlogSearchHistorySearchByUpdated) {
      yield* _mapSearchByUpdatedToState(event);
    }
  }

  Stream<FilteredBlogSearchHistoryState> _mapQueryUpdatedToState(_FilteredBlogSearchHistoryQueryUpdated event) async* {
    if (event.value.isEmpty) {
      yield FilteredBlogSearchHistoryState(values: _blogSearchHistoryBloc.state.getValuesBySearchBy(_searchBloc.state.searchBy));
      return;
    }

    List<String> currentValues = List.from(state.values);

    String lowerQuery = event.value.toLowerCase();

    currentValues
      ..removeWhere((element) {
        return !element.startsWith(lowerQuery);
      });

    yield FilteredBlogSearchHistoryState(values: currentValues);
  }

  Stream<FilteredBlogSearchHistoryState> _mapSearchByUpdatedToState(FilteredBlogSearchHistorySearchByUpdated event) async* {
    yield FilteredBlogSearchHistoryState(values: _blogSearchHistoryBloc.state.getValuesBySearchBy(_searchBloc.state.searchBy));
    add(_FilteredBlogSearchHistoryQueryUpdated(_searchBloc.state.search.value));
  }
}
