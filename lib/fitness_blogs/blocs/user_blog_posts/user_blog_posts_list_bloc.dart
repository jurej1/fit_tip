import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

part 'user_blog_posts_list_event.dart';
part 'user_blog_posts_list_state.dart';

class UserBlogPostsListBloc extends Bloc<UserBlogPostsListEvent, UserBlogPostsListState> {
  UserBlogPostsListBloc({
    required BlogRepository blogRepository,
    required AuthenticationBloc authenticationBloc,
    required SavedBlogPostsBloc savedBlogPostsBloc,
    required LikedBlogPostsBloc likedBlogPostsBloc,
  })  : _blogRepository = blogRepository,
        _authenticationBloc = authenticationBloc,
        _likedBlogPostsBloc = likedBlogPostsBloc,
        _savedBlogPostsBloc = savedBlogPostsBloc,
        super(UserBlogPostsListLoading());

  final BlogRepository _blogRepository;
  final AuthenticationBloc _authenticationBloc;
  final SavedBlogPostsBloc _savedBlogPostsBloc;
  final LikedBlogPostsBloc _likedBlogPostsBloc;

  final int _limit = 12;

  late DocumentSnapshot _lastFetchedDoc;

  @override
  Stream<UserBlogPostsListState> mapEventToState(
    UserBlogPostsListEvent event,
  ) async* {
    if (event is UserBlogPostsListLoadRequested) {
      yield* _mapLoadRequestToState(event);
    } else if (event is UserBlogPostsListLoadMoreRequested) {
      yield* _mapLoadMoreRequestedToState(event);
    } else if (event is UserBlogPostsListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is UserBlogPostsListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is UserBlogPostsListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    }
  }

  Stream<UserBlogPostsListState> _mapLoadRequestToState(UserBlogPostsListLoadRequested event) async* {
    if (_authenticationBloc.state.user?.uid == null) {
      yield UserBlogPostsListFail();
      return;
    }

    yield UserBlogPostsListLoading();

    try {
      QuerySnapshot snapshot = await _blogRepository.getBlogPostsByOwnerId(_authenticationBloc.state.user!.uid!, limit: _limit);
      if (snapshot.docs.isEmpty) {
        yield UserBlogPostsListLoadSuccess(blogs: [], hasReachedMax: true);
      } else {
        _lastFetchedDoc = snapshot.docs.last;

        List<BlogPost> blogs = BlogPost.mapQuerySnapshotToBlogPosts(
          snapshot,
          userId: _authenticationBloc.state.user!.uid,
          likedBlogIds: _likedBlogPostsBloc.state,
          saveBlogIds: _savedBlogPostsBloc.state,
        );
        yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: snapshot.size < _limit);
      }
    } catch (error) {
      yield UserBlogPostsListFail();
    }
  }

  Stream<UserBlogPostsListState> _mapLoadMoreRequestedToState(UserBlogPostsListLoadMoreRequested event) async* {
    if (state is UserBlogPostsListLoadSuccess) {
      final oldState = state as UserBlogPostsListLoadSuccess;
      List<BlogPost> oldBlogs = oldState.blogs;
      if (_authenticationBloc.state.user?.uid == null) {
        yield UserBlogPostsListFail();
        return;
      }

      try {
        QuerySnapshot snapshot = await _blogRepository.getBlogPostsByOwnerId(
          _authenticationBloc.state.user!.uid!,
          limit: _limit,
          startAfterDoc: _lastFetchedDoc,
        );
        if (snapshot.docs.isEmpty) {
          yield UserBlogPostsListLoadSuccess(blogs: oldBlogs, hasReachedMax: snapshot.size < _limit);
        } else {
          _lastFetchedDoc = snapshot.docs.last;
          List<BlogPost> blogs = oldBlogs +
              BlogPost.mapQuerySnapshotToBlogPosts(
                snapshot,
                userId: _authenticationBloc.state.user!.uid!,
                likedBlogIds: _likedBlogPostsBloc.state,
                saveBlogIds: _savedBlogPostsBloc.state,
              );
          yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: snapshot.size < _limit);
        }
      } catch (error) {
        log(error.toString());
        yield UserBlogPostsListFail();
      }
    }
  }

  Stream<UserBlogPostsListState> _mapItemAddedToState(UserBlogPostsListItemAdded event) async* {
    if (state is UserBlogPostsListLoadSuccess) {
      final oldState = state as UserBlogPostsListLoadSuccess;

      List<BlogPost> blogs = oldState.blogs;

      if (event.userId == event.blog.authorId) {
        if (blogs.isEmpty) {
          blogs.add(event.blog);
        } else {
          blogs.insert(0, event.blog);
        }
      }

      yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: oldState.hasReachedMax);
    }
  }

  Stream<UserBlogPostsListState> _mapItemRemovedToState(UserBlogPostsListItemRemoved event) async* {
    if (state is UserBlogPostsListLoadSuccess) {
      final oldState = state as UserBlogPostsListLoadSuccess;

      List<BlogPost> blogs = oldState.blogs;

      blogs.removeWhere((element) => element.id == event.blog.id);

      yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: oldState.hasReachedMax);
    }
  }

  Stream<UserBlogPostsListState> _mapItemUpdatedToState(UserBlogPostsListItemUpdated event) async* {
    if (state is UserBlogPostsListLoadSuccess && event.blog.authorId == event.userId) {
      final oldState = state as UserBlogPostsListLoadSuccess;

      List<BlogPost> blogs = oldState.blogs;

      blogs = blogs.map((e) {
        if (e.id == event.blog.id) {
          return event.blog;
        }
        return e;
      }).toList();

      yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: oldState.hasReachedMax);
    }
  }
}
