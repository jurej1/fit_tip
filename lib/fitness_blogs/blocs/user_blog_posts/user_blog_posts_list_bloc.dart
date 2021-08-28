import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'user_blog_posts_list_event.dart';
part 'user_blog_posts_list_state.dart';

class UserBlogPostsListBloc extends Bloc<UserBlogPostsListEvent, UserBlogPostsListState> {
  UserBlogPostsListBloc({
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(UserBlogPostsListLoading());

  final BlogRepository _blogRepository;
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
    if (event.userId == null) {
      yield UserBlogPostsListFail();
      return;
    }

    yield UserBlogPostsListLoading();

    try {
      QuerySnapshot snapshot = await _blogRepository.getBlogPostByOwnerId(event.userId!, limit: _limit);
      _lastFetchedDoc = snapshot.docs.last;

      List<BlogPost> blogs = BlogPost.mapQuerySnapshotToBlogPosts(snapshot, userId: event.userId!);
      yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: snapshot.size < _limit);
    } catch (error) {
      yield UserBlogPostsListFail();
    }
  }

  Stream<UserBlogPostsListState> _mapLoadMoreRequestedToState(UserBlogPostsListLoadMoreRequested event) async* {
    if (state is UserBlogPostsListLoadSuccess) {
      final oldState = state as UserBlogPostsListLoadSuccess;
      List<BlogPost> oldBlogs = oldState.blogs;
      if (event.userId == null) {
        yield UserBlogPostsListFail();
        return;
      }

      try {
        QuerySnapshot snapshot = await _blogRepository.getBlogPostByOwnerId(event.userId!, limit: _limit, startAfterDoc: _lastFetchedDoc);
        _lastFetchedDoc = snapshot.docs.last;

        List<BlogPost> blogs = oldBlogs + BlogPost.mapQuerySnapshotToBlogPosts(snapshot, userId: event.userId!);
        yield UserBlogPostsListLoadSuccess(blogs: blogs, hasReachedMax: snapshot.size < _limit);
      } catch (error) {
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
    if (state is UserBlogPostsListLoadSuccess) {
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
