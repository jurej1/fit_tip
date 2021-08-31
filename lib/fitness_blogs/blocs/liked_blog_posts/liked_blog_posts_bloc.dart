import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'liked_blog_posts_event.dart';

//TODO do it with authentication bloc

class LikedBlogPostsBloc extends HydratedBloc<LikedBlogPostsEvent, List<String>> {
  LikedBlogPostsBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        super([]);

  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<List<String>> mapEventToState(
    LikedBlogPostsEvent event,
  ) async* {
    if (event is LikedBlogPostsItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is LikedBlogPostsItemRemoved) {
      yield* _mapItemRemovedToState(event);
    }
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    return json['values'];
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) {
    return {'values': state};
  }

  Stream<List<String>> _mapItemAddedToState(LikedBlogPostsItemAdded event) async* {
    List<String> currentIds = List<String>.from(state);

    if (!currentIds.contains(event.id)) {
      currentIds.add(event.id);
    }

    yield currentIds;
  }

  Stream<List<String>> _mapItemRemovedToState(LikedBlogPostsItemRemoved event) async* {
    List<String> currentIds = List<String>.from(state);
    if (currentIds.contains(event.id)) {
      currentIds.remove(event.id);
    }

    yield currentIds;
  }
}
