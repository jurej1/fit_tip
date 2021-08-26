import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'saved_blog_posts_event.dart';
part 'saved_blog_posts_state.dart';

class SavedBlogPostsBloc extends HydratedBloc<SavedBlogPostsEvent, SavedBlogPostsState> {
  SavedBlogPostsBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _isAuth = authenticationBloc.state.isAuthenticated,
        _userId = authenticationBloc.state.user?.uid,
        super(SavedBlogPostsState()) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  String? _userId;
  bool _isAuth;

  late final StreamSubscription _authSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<SavedBlogPostsState> mapEventToState(
    SavedBlogPostsEvent event,
  ) async* {
    if (event is SavedBlogPostsItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is SavedBlogPostsItemRemoved) {
      yield* _mapItemRemovedToState(event);
    }
  }

  @override
  SavedBlogPostsState? fromJson(Map<String, dynamic> json) {
    if (_isAuth) {
      return SavedBlogPostsState(json[_userId]);
    }
  }

  @override
  Map<String, dynamic>? toJson(SavedBlogPostsState state) {
    if (_isAuth) {
      return {
        _userId!: state.blogIds,
      };
    }
  }

  Stream<SavedBlogPostsState> _mapItemAddedToState(SavedBlogPostsItemAdded event) async* {
    List<String> currentIds = List<String>.from(state.blogIds);

    if (!currentIds.contains(event.blogId)) {
      currentIds.add(event.blogId);
    }

    yield state.copyWith(blogIds: currentIds);
  }

  Stream<SavedBlogPostsState> _mapItemRemovedToState(SavedBlogPostsItemRemoved event) async* {
    List<String> currentIds = List<String>.from(state.blogIds);

    if (currentIds.contains(event.blogId)) {
      currentIds.remove(event.blogId);
    }
    yield state.copyWith(blogIds: currentIds);
  }
}
