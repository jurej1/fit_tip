import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

part 'blog_posts_saved_list_event.dart';
part 'blog_posts_saved_list_state.dart';

class BlogPostsSavedListBloc extends Bloc<BlogPostsSavedListEvent, BlogPostsSavedListState> {
  BlogPostsSavedListBloc({
    required BlogRepository blogRepository,
    required SavedBlogPostsBloc savedBlogPostsBloc,
    required AuthenticationBloc authenticationBloc,
    required LikedBlogPostsBloc likedBlogPostsBloc,
  })  : _blogRepository = blogRepository,
        _savedBlogsIds = savedBlogPostsBloc.state,
        _userId = authenticationBloc.state.user?.uid,
        _likedBlogIds = likedBlogPostsBloc.state,
        super(BlogPostsSavedListLoading()) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      _userId = authState.user?.uid;
      add(BlogPostsSavedListLoadRequested());
    });

    _savedBlogsSubscription = savedBlogPostsBloc.stream.listen((list) {
      _savedBlogsIds = list;
    });

    _likedBlogsSubscription = likedBlogPostsBloc.stream.listen((list) {
      _likedBlogIds = list;
    });
  }

  final BlogRepository _blogRepository;
  late final StreamSubscription _savedBlogsSubscription;
  late final StreamSubscription _authSubscription;
  late final StreamSubscription _likedBlogsSubscription;
  List<String> _savedBlogsIds;
  List<String> _likedBlogIds;
  String? _userId;

  final int _limit = 12;

  late DocumentSnapshot _lastFetchedDocumentSnapshot;

  @override
  Future<void> close() {
    _likedBlogsSubscription.cancel();
    _authSubscription.cancel();
    _savedBlogsSubscription.cancel();
    return super.close();
  }

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
      yield* _mapLoadMoreRequestedToState();
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
    List<BlogPost> blogs = const [];
    List<String> savedBlogIds = List<String>.from(_savedBlogsIds);

    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;
      blogs = oldState.blogs;
      savedBlogIds = _mapBlogPostsToNotFetchedBlogIds(blogs);
    }

    yield BlogPostsSavedListLoading();

    try {
      QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsQueryByIds(
        limit: _limit,
        blogIds: savedBlogIds,
      );
      _lastFetchedDocumentSnapshot = querySnapshot.docs.last;

      blogs = blogs +
          BlogPost.mapQuerySnapshotToBlogPosts(
            querySnapshot,
            userId: _userId,
            saveBlogIds: _savedBlogsIds,
            likedBlogIds: _likedBlogIds,
          );

      yield BlogPostsSavedListLoadSuccess(
        blogs: blogs,
        hasReachedMax: querySnapshot.docs.length < _limit,
      );
    } catch (error) {
      yield BlogPostsSavedListFailure();
    }
  }

  Stream<BlogPostsSavedListState> _mapLoadMoreRequestedToState() async* {
    if (state is BlogPostsSavedListLoadSuccess) {
      final oldState = state as BlogPostsSavedListLoadSuccess;
      List<BlogPost> blogPosts = oldState.blogs;
      List<String> _allIds = _mapBlogPostsToNotFetchedBlogIds(blogPosts);

      try {
        QuerySnapshot snapshot = await _blogRepository.getBlogPostsQueryByIds(
          limit: _limit,
          blogIds: _allIds,
          startAfterDoc: _lastFetchedDocumentSnapshot,
        );

        blogPosts = blogPosts +
            BlogPost.mapQuerySnapshotToBlogPosts(
              snapshot,
              userId: _userId,
              likedBlogIds: _likedBlogIds,
              saveBlogIds: _savedBlogsIds,
            );
        yield BlogPostsSavedListLoadSuccess(
          blogs: blogPosts,
          hasReachedMax: snapshot.size < _limit,
        );
      } catch (error) {
        yield BlogPostsSavedListFailure();
      }
    }
  }

  List<String> _mapBlogPostsToNotFetchedBlogIds(List<BlogPost> posts) {
    return List<String>.from(_savedBlogsIds)..removeWhere((savedId) => posts.any((element) => element.id == savedId));
  }
}
