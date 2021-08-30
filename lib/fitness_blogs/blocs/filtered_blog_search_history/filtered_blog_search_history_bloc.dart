import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/fitness_blogs/blocs/blog_search_history/blog_search_history_bloc.dart';

part 'filtered_blog_search_history_event.dart';
part 'filtered_blog_search_history_state.dart';

class FilteredBlogSearchHistoryBloc extends Bloc<FilteredBlogSearchHistoryEvent, FilteredBlogSearchHistoryState> {
  FilteredBlogSearchHistoryBloc({
    required BlogSearchHistoryBloc blogSearchHistoryBloc,
    required SearchBy searchBy,
  })  : _blogSearchHistoryBloc = blogSearchHistoryBloc,
        super(
          FilteredBlogSearchHistoryState(
            values: blogSearchHistoryBloc.state.getValuesBySearchBy(searchBy),
          ),
        );

  final BlogSearchHistoryBloc _blogSearchHistoryBloc;

  @override
  Stream<FilteredBlogSearchHistoryState> mapEventToState(
    FilteredBlogSearchHistoryEvent event,
  ) async* {
    if (event is FilteredBlogSearchHistoryQueryUpdated) {
      yield* _mapQueryUpdatedToState(event);
    } else if (event is FilteredBlogSearchHistorySearchByUpdated) {
      yield* _mapSearchByUpdatedToState(event);
    }
  }

  Stream<FilteredBlogSearchHistoryState> _mapQueryUpdatedToState(FilteredBlogSearchHistoryQueryUpdated event) async* {
    List<String> currentValues = List.from(state.values);

    String lowerQuery = event.value.toLowerCase();

    currentValues
      ..removeWhere((element) {
        return !element.startsWith(lowerQuery);
      });

    yield FilteredBlogSearchHistoryState(values: currentValues);
  }

  Stream<FilteredBlogSearchHistoryState> _mapSearchByUpdatedToState(FilteredBlogSearchHistorySearchByUpdated event) async* {
    yield FilteredBlogSearchHistoryState(values: _blogSearchHistoryBloc.state.getValuesBySearchBy(event.searchBy));
  }
}
