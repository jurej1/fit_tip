import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'blog_search_history_event.dart';
part 'blog_search_history_state.dart';

class BlogSearchHistoryBloc extends HydratedBloc<BlogSearchHistoryEvent, BlogSearchHistoryState> {
  BlogSearchHistoryBloc() : super(BlogSearchHistoryState.initial());

  @override
  Stream<BlogSearchHistoryState> mapEventToState(
    BlogSearchHistoryEvent event,
  ) async* {
    if (event is BlogSearchHistoryItemAdded) {
      yield* _mapHistoryAddedToState(event);
    }
  }

  @override
  BlogSearchHistoryState? fromJson(Map<String, dynamic> json) {
    return BlogSearchHistoryState(
      byTags: json['byTags'],
      byAuthor: json['byAuthor'],
      byTitle: json['byTitle'],
    );
  }

  @override
  Map<String, dynamic>? toJson(BlogSearchHistoryState state) {
    return {
      'byTags': state.byTags,
      'byAuthor': state.byAuthor,
      'byTitle': state.byTitle,
    };
  }

  Stream<BlogSearchHistoryState> _mapHistoryAddedToState(BlogSearchHistoryItemAdded event) async* {
    if (event.searchBy.isTags) {
      yield state.copyWith(
        byTags: _mapItemAdded(state.byTags, event.value),
      );
    }

    if (event.searchBy.isAuthor) {
      yield state.copyWith(
        byAuthor: _mapItemAdded(state.byAuthor, event.value),
      );
    }

    if (event.searchBy.isTitle) {
      yield state.copyWith(
        byTitle: _mapItemAdded(state.byTitle, event.value),
      );
    }
  }

  List<String> _mapItemAdded(List<String> currentValues, String value) {
    final history = List<String>.from(currentValues);

    if (history.length > 5) {
      history.removeAt(0);

      history.add(value);
      return history;
    }

    if (!history.contains(value)) {
      history.add(value);
    }
    return history;
  }
}
