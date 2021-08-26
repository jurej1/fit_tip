import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'saved_blog_posts_event.dart';

class SavedBlogPostsBloc extends HydratedBloc<SavedBlogPostsEvent, List<String>> {
  SavedBlogPostsBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _isAuth = authenticationBloc.state.isAuthenticated,
        _userId = authenticationBloc.state.user?.uid,
        super([]) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
      add(_SavedBlogPostsAuthUpdated());
    });
  }

  String? _userId;
  bool _isAuth;
  late Map<String, dynamic> allIdsJson;

  late final StreamSubscription _authSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<List<String>> mapEventToState(
    SavedBlogPostsEvent event,
  ) async* {
    if (event is SavedBlogPostsItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is SavedBlogPostsItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is _SavedBlogPostsAuthUpdated) {
      if (_isAuth) {
        yield (allIdsJson[_userId!] as List<dynamic>).map((e) => e.toString()).toList();
      }
    }
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    allIdsJson = json;
    if (_isAuth) {
      return json[_userId];
    }
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) {
    if (_isAuth) {
      return {
        _userId!: state,
      };
    }
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
