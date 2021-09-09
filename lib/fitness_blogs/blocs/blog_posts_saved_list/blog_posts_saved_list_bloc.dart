import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

import '../../fitness_blogs.dart';

part 'blog_posts_saved_list_event.dart';
part 'blog_posts_saved_list_state.dart';

class BlogPostsSavedListBloc extends Bloc<BlogPostsSavedListEvent, BlogPostsSavedListState> {
  BlogPostsSavedListBloc({
    required BlogRepository blogRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _blogRepository = blogRepository,
        _authenticationBloc = authenticationBloc,
        super(BlogPostsSavedListLoading());

  final BlogRepository _blogRepository;
  final int _limit = 12;
  DocumentSnapshot? _lastFetchedDocumentSnapshot;

  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<BlogPostsSavedListState> mapEventToState(
    BlogPostsSavedListEvent event,
  ) async* {
    if (event is BlogPostsSavedListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is BlogPostsSavedListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is BlogPostsSavedListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is BlogPostsSavedListLoadRequested) {
      yield* _mapLoadRequestedToState();
    } else if (event is BlogPostsSavedListLoadMoreRequested) {
      yield* _mapLoadMoreRequestedToState(event);
    }
  }

  Stream<BlogPostsSavedListState> _mapItemAddedToState(BlogPostsSavedListItemAdded event) async* {
    if (state is BlogPostsSavedListLoadSuccess) {
      final oldState = state as BlogPostsSavedListLoadSuccess;

      List<BlogPost> blogs = List.from(oldState.blogs);

      if (blogs.isEmpty) {
        blogs.add(event.blog);
      } else {
        blogs.insert(0, event.blog);
      }

      yield oldState.copyWith(blogs: blogs);
    } else {
      yield BlogPostsSavedListLoadSuccess(
        hasReachedMax: false,
        blogs: [event.blog],
      );
    }
  }

  Stream<BlogPostsSavedListState> _mapItemRemovedToState(BlogPostsSavedListItemRemoved event) async* {
    if (state is BlogPostsSavedListLoadSuccess) {
      final oldState = state as BlogPostsSavedListLoadSuccess;

      List<BlogPost> blogPosts = List.from(oldState.blogs);

      blogPosts.removeWhere((element) => element.id == event.blog.id);

      yield oldState.copyWith(
        blogs: blogPosts,
      );
    }
  }

  Stream<BlogPostsSavedListState> _mapItemUpdatedToState(BlogPostsSavedListItemUpdated event) async* {
    if (state is BlogPostsSavedListLoadSuccess) {
      final oldState = state as BlogPostsSavedListLoadSuccess;

      List<BlogPost> blogPosts = List.from(oldState.blogs);

      blogPosts = blogPosts.map((e) {
        if (e.id == event.blog.id) {
          return event.blog;
        }
        return e;
      }).toList();

      yield oldState.copyWith(blogs: blogPosts);
    }
  }

  Stream<BlogPostsSavedListState> _mapLoadRequestedToState() async* {
    if (_authenticationBloc.state.isAuthenticated == false) {
      yield BlogPostsSavedListFailure();
      return;
    }

    List<BlogPost> blogs = const [];
    List<String> savedBlogIds = List<String>.from(_blogRepository.getSavedBlogIds(_authenticationBloc.state.user!.uid!));

    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;
      blogs = oldState.blogs;
      savedBlogIds = _mapBlogPostsToNotFetchedBlogIds(savedBlogIds, blogs);
    }

    if (savedBlogIds.isEmpty) {
      yield BlogPostsSavedListLoadSuccess(blogs: [], hasReachedMax: true);
      return;
    }

    yield BlogPostsSavedListLoading();

    try {
      QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsByBlogIds(
        limit: _limit,
        blogIds: savedBlogIds,
      );

      if (querySnapshot.docs.isEmpty) {
        yield BlogPostsSavedListLoadSuccess(blogs: blogs, hasReachedMax: querySnapshot.docs.length < _limit);
      } else {
        _lastFetchedDocumentSnapshot = querySnapshot.docs.last;

        blogs = blogs +
            BlogPost.mapQuerySnapshotToBlogPosts(
              querySnapshot,
              userId: _authenticationBloc.state.user?.uid,
              saveBlogIds: savedBlogIds,
              likedBlogIds: _blogRepository.getLikedBlogIds(_authenticationBloc.state.user!.uid!),
            );

        yield BlogPostsSavedListLoadSuccess(
          blogs: blogs,
          hasReachedMax: querySnapshot.docs.length < _limit,
        );
      }
    } catch (error) {
      log(error.toString());
      yield BlogPostsSavedListFailure();
    }
  }

  Stream<BlogPostsSavedListState> _mapLoadMoreRequestedToState(BlogPostsSavedListLoadMoreRequested event) async* {
    if (state is BlogPostsSavedListLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final oldState = state as BlogPostsSavedListLoadSuccess;
      List<BlogPost> blogPosts = oldState.blogs;
      List<String> _allIds = _mapBlogPostsToNotFetchedBlogIds(
        _blogRepository.getSavedBlogIds(
          _authenticationBloc.state.user!.uid!,
        ),
        blogPosts,
      );

      if (_allIds.isEmpty) {
        return;
      }

      try {
        QuerySnapshot snapshot = await _blogRepository.getBlogPostsByBlogIds(
          limit: _limit,
          blogIds: _allIds,
          startAfterDoc: _lastFetchedDocumentSnapshot,
        );

        if (snapshot.docs.isEmpty) {
          yield BlogPostsSavedListLoadSuccess(blogs: blogPosts, hasReachedMax: snapshot.docs.length < _limit);
        } else {
          _lastFetchedDocumentSnapshot = snapshot.docs.last;

          blogPosts = blogPosts + _mapQuerySnapshotToList(snapshot);
          yield BlogPostsSavedListLoadSuccess(
            blogs: blogPosts,
            hasReachedMax: snapshot.size < _limit,
          );
        }
      } catch (error) {
        yield BlogPostsSavedListFailure();
      }
    }
  }

  List<String> _mapBlogPostsToNotFetchedBlogIds(List<String> savedBlogIds, List<BlogPost> posts) {
    return List<String>.from(savedBlogIds)..removeWhere((savedId) => posts.any((element) => element.id == savedId));
  }

  List<BlogPost> _mapQuerySnapshotToList(QuerySnapshot querySnapshot) {
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
