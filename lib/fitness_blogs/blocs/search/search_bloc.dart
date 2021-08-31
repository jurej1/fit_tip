import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/models/models.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

enum SearchBy { title, tags, author }

extension SearchByX on SearchBy {
  bool get isTitle => this == SearchBy.title;
  bool get isTags => this == SearchBy.tags;
  bool get isAuthor => this == SearchBy.author;

  String toStringReadable() {
    if (isTitle) return 'Title';
    if (isTags) return 'Tag';
    if (isAuthor) return 'Author';

    return '';
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! SearchQueryUpdated);

    final debounceStream = events.where((event) => event is SearchQueryUpdated).debounceTime(const Duration(milliseconds: 300));

    return super.transformEvents(MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchQueryUpdated) {
      yield* _mapQueryUpdatedToState(event);
    } else if (event is SearchQueryUpdated) {
      yield* _mapClearRequestedToState();
    } else if (event is SearchByUpdated) {
      yield state.copyWith(searchBy: event.value);
    }
  }

  Stream<SearchState> _mapQueryUpdatedToState(SearchQueryUpdated event) async* {
    final search = Search.dirty(event.query);

    yield state.copyWith(search: search);
  }

  Stream<SearchState> _mapClearRequestedToState() async* {
    final currentQuery = state.search.value;

    if (currentQuery.isNotEmpty) {
      yield state.copyWith(search: Search.pure());
    }
  }
}
