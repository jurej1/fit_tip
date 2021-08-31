import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'liked_blog_posts_event.dart';

class LikedBlogPostsBloc extends HydratedBloc<LikedBlogPostsEvent, List<String>> {
  LikedBlogPostsBloc({required AuthenticationBloc authenticationBloc})
      : _isAuth = authenticationBloc.state.isAuthenticated,
        _userId = authenticationBloc.state.user?.uid,
        super([]) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authenticationBloc.state.isAuthenticated;
      _userId = authenticationBloc.state.user?.uid;
    });
  }

  late final StreamSubscription _authSubscription;

  bool _isAuth;
  String? _userId;

  late Map<String, dynamic> _allIds;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
    _allIds = json;
    if (_isAuth) {
      return (json[_userId!] as List<dynamic>).map((e) => e.toString()).toList();
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
