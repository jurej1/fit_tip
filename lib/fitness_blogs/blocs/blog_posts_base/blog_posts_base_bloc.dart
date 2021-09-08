import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'blog_posts_base_event.dart';
part 'blog_posts_base_state.dart';

abstract class BlogPostsBaseBloc extends Bloc<BlogPostsBaseEvent, BlogPostsBaseState> {
  BlogPostsBaseBloc(
    BlogPostsBaseState initialState, {
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
  })  : _authenticationBloc = authenticationBloc,
        _blogRepository = blogRepository,
        super(initialState);

  final AuthenticationBloc _authenticationBloc;
  final BlogRepository _blogRepository;

  @override
  Stream<BlogPostsBaseState> mapEventToState(
    BlogPostsBaseEvent event,
  ) async* {
    if (event is BlogPostsLoadRequested) {
      yield* mapLoadRequestedToState(event);
    } else if (event is BlogPostsLoadMoreRequested) {
      yield* mapLoadMoreRequestedToState(event);
    } else if (event is BlogPostsItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is BlogPostsItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is BlogPostsItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    }
  }

  Stream<BlogPostsBaseState> mapLoadRequestedToState(BlogPostsLoadRequested event);

  Stream<BlogPostsBaseState> mapLoadMoreRequestedToState(BlogPostsLoadMoreRequested event);

  Stream<BlogPostsBaseState> _mapItemAddedToState(BlogPostsItemAdded event) async* {
    if (state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;
      List<BlogPost> blogs = oldState.blogPosts;

      blogs.add(event.value);

      yield BlogPostsLoadSuccess(blogs, oldState.hasReachedMax);
    }
  }

  Stream<BlogPostsBaseState> _mapItemRemovedToState(BlogPostsItemRemoved event) async* {
    if (state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;
      List<BlogPost> blogs = oldState.blogPosts;

      blogs.removeWhere((element) => element.id == event.value.id);

      yield BlogPostsLoadSuccess(blogs, oldState.hasReachedMax);
    }
  }

  Stream<BlogPostsBaseState> _mapItemUpdatedToState(BlogPostsItemUpdated event) async* {
    if (state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;
      List<BlogPost> blogs = oldState.blogPosts;

      blogs = blogs.map((e) {
        if (e.id == event.value.id) {
          return event.value;
        }

        return e;
      }).toList();

      yield BlogPostsLoadSuccess(blogs, oldState.hasReachedMax);
    }
  }

  List<BlogPost> mapQuerySnapshotToList(QuerySnapshot querySnapshot) {
    if (_authenticationBloc.state.isAuthenticated) {
      String uid = _authenticationBloc.state.user!.uid!;

      return BlogPost.mapQuerySnapshotToBlogPosts(
        querySnapshot,
        likedBlogIds: _blogRepository.getLikedBlogIds(uid),
        saveBlogIds: _blogRepository.getSavedBlogIds(uid),
        userId: uid,
      );
    }

    return BlogPost.mapQuerySnapshotToBlogPosts(querySnapshot);
  }
}
