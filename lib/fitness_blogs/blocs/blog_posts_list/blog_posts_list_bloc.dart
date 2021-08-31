import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';

part 'blog_posts_list_event.dart';
part 'blog_posts_list_state.dart';

class BlogPostsListBloc extends Bloc<BlogPostsListEvent, BlogPostsListState> {
  BlogPostsListBloc({
    required BlogRepository blogRepository,
    required SavedBlogPostsBloc savedBlogPostsBloc,
    required LikedBlogPostsBloc likedBlogPostsBloc,
    required BlogPostsSearchFilterBloc blogPostsSearchFilterBloc,
  })  : _blogRepository = blogRepository,
        _searchFilterBloc = blogPostsSearchFilterBloc,
        super(BlogPostsListLoading()) {
    _savedBlogsSubscription = savedBlogPostsBloc.stream.listen((savedBlogsState) {
      add(_BlogPostsListSavedBlogsUpdated(savedBlogsState));
    });

    _likedBlogPostsSubscription = likedBlogPostsBloc.stream.listen((likedBlogState) {
      add(_BlogPostsListLikedBlogsUpdated(likedBlogState));
    });

    _searchFilterSubscription = _searchFilterBloc.stream.listen((searchFilterState) {
      add(BlogPostsListLoadRequested(likedBlogs: likedBlogPostsBloc.state, savedBlogs: savedBlogPostsBloc.state));
    });
  }

  late final StreamSubscription _savedBlogsSubscription;
  late final StreamSubscription _likedBlogPostsSubscription;
  late final StreamSubscription _searchFilterSubscription;

  final BlogPostsSearchFilterBloc _searchFilterBloc;

  final BlogRepository _blogRepository;
  late DocumentSnapshot _lastFetchedDoc;
  final int _limit = 12;

  @override
  Future<void> close() {
    _likedBlogPostsSubscription.cancel();
    _savedBlogsSubscription.cancel();
    _searchFilterSubscription.cancel();
    return super.close();
  }

  @override
  Stream<BlogPostsListState> mapEventToState(
    BlogPostsListEvent event,
  ) async* {
    if (event is BlogPostsListLoadRequested) {
      yield* _mapLoadRequestedToState(event);
    } else if (event is BlogPostsListLoadMore) {
      yield* _mapLoadMoreToState(event);
    } else if (event is BlogPostsListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is BlogPostsListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is BlogPostsListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is _BlogPostsListSavedBlogsUpdated) {
      yield* _mapSavedBlogsUpdatedToState(event);
    } else if (event is _BlogPostsListLikedBlogsUpdated) {
      yield* _mapLikedBlogsUpdatedToState(event);
    }
  }

  Stream<BlogPostsListState> _mapLoadRequestedToState(BlogPostsListLoadRequested event) async* {
    yield BlogPostsListLoading();

    try {
      QuerySnapshot snapshot = await _blogRepository.getBlogPostsByCreated(limit: _limit);
      _lastFetchedDoc = snapshot.docs.last;

      if (snapshot.size == 0) {
        yield BlogPostsListLoadSuccess(hasReachedMax: true);
        return;
      }

      List<BlogPost> blogs = BlogPost.mapQuerySnapshotToBlogPosts(
        snapshot,
        likedBlogIds: event.likedBlogs,
        saveBlogIds: event.savedBlogs,
        userId: event.userId,
      );

      yield BlogPostsListLoadSuccess(
        blogs: blogs,
        hasReachedMax: snapshot.size < _limit,
      );
    } catch (e) {
      yield BlogPostsListFail();
    }
  }

  Stream<BlogPostsListState> _mapLoadMoreToState(BlogPostsListLoadMore event) async* {
    if (this.state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      if (!oldState.hasReachedMax) {
        try {
          QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsByCreated(limit: _limit, startAfterDoc: _lastFetchedDoc);
          if (querySnapshot.docs.isEmpty) {
            yield BlogPostsListLoadSuccess(hasReachedMax: querySnapshot.size < _limit, blogs: oldState.blogs);
          } else {
            _lastFetchedDoc = querySnapshot.docs.last;

            yield BlogPostsListLoadSuccess(
              hasReachedMax: querySnapshot.size < _limit,
              blogs: oldState.blogs +
                  BlogPost.mapQuerySnapshotToBlogPosts(
                    querySnapshot,
                    likedBlogIds: event.likedBlogs,
                    saveBlogIds: event.savedBlogs,
                    userId: event.userId,
                  ),
            );
          }
        } catch (error) {
          yield BlogPostsListFail();
        }
      }
    }
  }

  Stream<BlogPostsListState> _mapItemAddedToState(BlogPostsListItemAdded event) async* {
    if (state is BlogPostsListLoadSuccess) {
      final currentState = state as BlogPostsListLoadSuccess;

      List<BlogPost> blogs = currentState.blogs
        ..add(event.value)
        ..sort((a, b) => b.created.compareTo(a.created));

      yield BlogPostsListLoadSuccess(hasReachedMax: currentState.hasReachedMax, blogs: blogs);
    }
  }

  Stream<BlogPostsListState> _mapItemRemovedToState(BlogPostsListItemRemoved event) async* {
    if (state is BlogPostsListLoadSuccess) {
      final currentState = state as BlogPostsListLoadSuccess;

      List<BlogPost> blogs = currentState.blogs..removeWhere((element) => element.id == event.value.id);

      yield BlogPostsListLoadSuccess(hasReachedMax: currentState.hasReachedMax, blogs: blogs);
    }
  }

  Stream<BlogPostsListState> _mapItemUpdatedToState(BlogPostsListItemUpdated event) async* {
    if (state is BlogPostsListLoadSuccess) {
      final currentState = state as BlogPostsListLoadSuccess;

      List<BlogPost> blogs = currentState.blogs.map((e) {
        if (e.id == event.value.id) {
          return event.value;
        }
        return e;
      }).toList();

      yield BlogPostsListLoadSuccess(hasReachedMax: currentState.hasReachedMax, blogs: blogs);
    }
  }

  Stream<BlogPostsListState> _mapSavedBlogsUpdatedToState(_BlogPostsListSavedBlogsUpdated event) async* {
    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      List<BlogPost> posts = List.from(oldState.blogs);

      posts = posts
          .map(
            (e) => e.copyWith(isSaved: event.ids.contains(e.id)),
          )
          .toList();

      yield BlogPostsListLoadSuccess(hasReachedMax: oldState.hasReachedMax, blogs: posts);
    }
  }

  Stream<BlogPostsListState> _mapLikedBlogsUpdatedToState(_BlogPostsListLikedBlogsUpdated event) async* {
    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      List<BlogPost> posts = List.from(oldState.blogs);

      posts = posts
          .map(
            (e) => e.copyWith(like: event.ids.contains(e.id) ? Like.yes : Like.no),
          )
          .toList();

      yield BlogPostsListLoadSuccess(hasReachedMax: oldState.hasReachedMax, blogs: posts);
    }
  }

  Future<QuerySnapshot> _mapSearchFilterToQuerySnapshot() {
    BlogSearchResult? result = _searchFilterBloc.state;

    if (result?.searchBy.isAuthor ?? false) {
      return _blogRepository.getBlogPostsByAuthor(result!.query, limit: _limit);
    } else if (result?.searchBy.isTags ?? false) {
      return _blogRepository.getBlogPostsByTag(result!.query, limit: _limit);
    } else if (result?.searchBy.isTitle ?? false) {
      return _blogRepository.getBlogPostsByTitle(result!.query, limit: _limit);
    } else {
      return _blogRepository.getBlogPostsByCreated(limit: _limit);
    }
  }
}
