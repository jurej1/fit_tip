import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

part 'blog_posts_list_event.dart';
part 'blog_posts_list_state.dart';

class BlogPostsListBloc extends Bloc<BlogPostsListEvent, BlogPostsListState> {
  BlogPostsListBloc({
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
    required SavedBlogPostsBloc savedBlogPostsBloc,
    required LikedBlogPostsBloc likedBlogPostsBloc,
  })  : _blogRepository = blogRepository,
        _savedBlogsIds = savedBlogPostsBloc.state,
        _likedBlogsIds = likedBlogPostsBloc.state,
        _isAuth = authenticationBloc.state.isAuthenticated,
        _userId = authenticationBloc.state.user?.uid,
        super(BlogPostsListLoading()) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      add(_BlogPostAuthUpdated(authState));
      add(BlogPostsListLoadRequested());
    });

    _savedBlogsSubscription = savedBlogPostsBloc.stream.listen((savedBlogsState) {
      add(_BlogPostsListSavedBlogsUpdated(savedBlogsState));
    });

    _likedBlogPostsSubscription = likedBlogPostsBloc.stream.listen((likedBlogState) {
      add(_BlogPostsListLikedBlogsUpdated(likedBlogState));
    });
  }

  late final StreamSubscription _authSubscription;
  late final StreamSubscription _savedBlogsSubscription;
  late final StreamSubscription _likedBlogPostsSubscription;

  final BlogRepository _blogRepository;

  bool _isAuth = false;
  String? _userId;
  List<String> _savedBlogsIds;
  List<String> _likedBlogsIds;

  late DocumentSnapshot _lastFetchedDoc;

  final int _limit = 12;

  @override
  Future<void> close() {
    _likedBlogPostsSubscription.cancel();
    _savedBlogsSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<BlogPostsListState> mapEventToState(
    BlogPostsListEvent event,
  ) async* {
    if (event is _BlogPostAuthUpdated) {
      _isAuth = event.value.isAuthenticated;
      _userId = event.value.user?.uid;
      add(BlogPostsListLoadRequested());
    } else if (event is BlogPostsListLoadRequested) {
      yield* _mapLoadRequestedToState();
    } else if (event is BlogPostsListLoadMore) {
      yield* _mapLoadMoreToState();
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

  Stream<BlogPostsListState> _mapLoadRequestedToState() async* {
    yield BlogPostsListLoading();

    try {
      QuerySnapshot snapshot = await _blogRepository.getBlogPostByCreated(limit: _limit);
      _lastFetchedDoc = snapshot.docs.last;

      if (snapshot.size == 0) {
        yield BlogPostsListLoadSuccess(hasReachedMax: true);
        return;
      }

      yield BlogPostsListLoadSuccess(
        blogs: _mapQuerySnapshotToBlogPosts(snapshot),
        hasReachedMax: snapshot.size < _limit,
      );
    } catch (e) {
      yield BlogPostsListFail();
    }
  }

  Stream<BlogPostsListState> _mapLoadMoreToState() async* {
    if (this.state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      if (!oldState.hasReachedMax) {
        try {
          QuerySnapshot querySnapshot = await _blogRepository.getBlogPostByCreated(limit: _limit, startAfterDoc: _lastFetchedDoc);
          _lastFetchedDoc = querySnapshot.docs.last;

          yield BlogPostsListLoadSuccess(
            hasReachedMax: querySnapshot.size < _limit,
            blogs: oldState.blogs + _mapQuerySnapshotToBlogPosts(querySnapshot),
          );
        } catch (error) {
          yield BlogPostsListFail();
        }
      }
    }
  }

  List<BlogPost> _mapQuerySnapshotToBlogPosts(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      BlogPost blog = BlogPost.fromEntity(BlogPostEntity.fromDocumentSnapshot(e));

      if (_isAuth) {
        blog = blog.copyWith(
          isAuthor: _userId! == blog.authorId,
          like: Like.no, //TODO with hydrated bloc
          isSaved: _savedBlogsIds.contains(blog.id),
        );
      }

      return blog;
    }).toList();
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
    _savedBlogsIds = event.ids;
    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      List<BlogPost> posts = List.from(oldState.blogs);

      posts = posts
          .map(
            (e) => e.copyWith(isSaved: _savedBlogsIds.contains(e.id)),
          )
          .toList();

      yield BlogPostsListLoadSuccess(hasReachedMax: oldState.hasReachedMax, blogs: posts);
    }
  }

  Stream<BlogPostsListState> _mapLikedBlogsUpdatedToState(_BlogPostsListLikedBlogsUpdated event) async* {
    _likedBlogsIds = event.ids;
    if (state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

      List<BlogPost> posts = List.from(oldState.blogs);

      posts = posts
          .map(
            (e) => e.copyWith(like: _likedBlogsIds.contains(e.id) ? Like.yes : Like.no),
          )
          .toList();

      yield BlogPostsListLoadSuccess(hasReachedMax: oldState.hasReachedMax, blogs: posts);
    }
  }
}
