import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'saved_blog_posts_event.dart';

//TODO do it with authentication

class SavedBlogPostsBloc extends HydratedBloc<SavedBlogPostsEvent, List<String>> {
  SavedBlogPostsBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        super([]);

  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<List<String>> mapEventToState(
    SavedBlogPostsEvent event,
  ) async* {
    if (event is SavedBlogPostsItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is SavedBlogPostsItemRemoved) {
      yield* _mapItemRemovedToState(event);
    }
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    if (json['values'] == null) return [];
    return json['values'];
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) {
    return {'values': state};
  }

  Stream<List<String>> _mapItemAddedToState(SavedBlogPostsItemAdded event) async* {
    List<String> currentIds = List<String>.from(state);

    if (!currentIds.contains(event.blogId)) {
      currentIds.add(event.blogId);
    }

    yield currentIds;
  }

  Stream<List<String>> _mapItemRemovedToState(SavedBlogPostsItemRemoved event) async* {
    List<String> currentIds = List<String>.from(state);

    if (currentIds.contains(event.blogId)) {
      currentIds.remove(event.blogId);
    }
    yield currentIds;
  }
}
