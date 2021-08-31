import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
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
    required AuthenticationBloc authenticationBloc,
  })  : _blogRepository = blogRepository,
        _searchFilterBloc = blogPostsSearchFilterBloc,
        _likedBlogPostsBloc = likedBlogPostsBloc,
        _savedBlogPostsBloc = savedBlogPostsBloc,
        _authenticationBloc = authenticationBloc,
        super(BlogPostsListLoading()) {
    _savedBlogsSubscription = savedBlogPostsBloc.stream.listen((savedBlogsState) {
      add(_BlogPostsListSavedBlogsUpdated(savedBlogsState));
    });

    _likedBlogPostsSubscription = likedBlogPostsBloc.stream.listen((likedBlogState) {
      add(_BlogPostsListLikedBlogsUpdated(likedBlogState));
    });

    _searchFilterSubscription = _searchFilterBloc.stream.listen((searchFilterState) {
      add(BlogPostsListLoadRequested());
    });
  }

  late final StreamSubscription _savedBlogsSubscription;
  late final StreamSubscription _likedBlogPostsSubscription;
  late final StreamSubscription _searchFilterSubscription;

  final BlogPostsSearchFilterBloc _searchFilterBloc;
  final LikedBlogPostsBloc _likedBlogPostsBloc;
  final SavedBlogPostsBloc _savedBlogPostsBloc;
  final AuthenticationBloc _authenticationBloc;

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
      yield* _mapLoadRequestedToState();
    } else if (event is BlogPostsListLoadMore) {
      yield* _mapLoadMoreToState();
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

  Stream<BlogPostsListState> _mapLoadRequestedToState() async* {
    yield BlogPostsListLoading();

    try {
      QuerySnapshot snapshot = await _mapSearchFilterToQuerySnapshot();

      if (snapshot.size == 0) {
        yield BlogPostsListLoadSuccess(hasReachedMax: true);
        return;
      } else {
        _lastFetchedDoc = snapshot.docs.last;

        List<BlogPost> blogs = BlogPost.mapQuerySnapshotToBlogPosts(
          snapshot,
          likedBlogIds: _likedBlogPostsBloc.state,
          saveBlogIds: _savedBlogPostsBloc.state,
          userId: _authenticationBloc.state.user?.uid,
        );

        yield BlogPostsListLoadSuccess(
          blogs: blogs,
          hasReachedMax: snapshot.size < _limit,
        );
      }
    } catch (e) {
      yield BlogPostsListFail();
    }
  }

  Stream<BlogPostsListState> _mapLoadMoreToState() async* {
    if (this.state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      if (!oldState.hasReachedMax) {
        try {
          QuerySnapshot querySnapshot = await _mapSearchFilterToQuerySnapshot(lastFetchedDoc: _lastFetchedDoc);
          if (querySnapshot.docs.isEmpty) {
            yield BlogPostsListLoadSuccess(hasReachedMax: querySnapshot.size < _limit, blogs: oldState.blogs);
          } else {
            _lastFetchedDoc = querySnapshot.docs.last;

            yield BlogPostsListLoadSuccess(
              hasReachedMax: querySnapshot.size < _limit,
              blogs: oldState.blogs +
                  BlogPost.mapQuerySnapshotToBlogPosts(
                    querySnapshot,
                    likedBlogIds: _likedBlogPostsBloc.state,
                    saveBlogIds: _savedBlogPostsBloc.state,
                    userId: _authenticationBloc.state.user?.uid,
                  ),
            );
          }
        } catch (error) {
          yield BlogPostsListFail();
        }
      }
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

  Future<QuerySnapshot> _mapSearchFilterToQuerySnapshot({DocumentSnapshot? lastFetchedDoc}) {
    BlogSearchResult? result = _searchFilterBloc.state;

    if (result?.searchBy.isAuthor ?? false) {
      return _blogRepository.getBlogPostsByAuthor(result!.query, limit: _limit, startAfterDoc: lastFetchedDoc);
    } else if (result?.searchBy.isTags ?? false) {
      return _blogRepository.getBlogPostsByTag(result!.query, limit: _limit, startAfterDoc: lastFetchedDoc);
    } else if (result?.searchBy.isTitle ?? false) {
      return _blogRepository.getBlogPostsByTitle(result!.query, limit: _limit, startAfterDoc: lastFetchedDoc);
    } else {
      return _blogRepository.getBlogPostsByCreated(limit: _limit, startAfterDoc: lastFetchedDoc);
    }
  }
}
