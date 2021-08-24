import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'blog_posts_list_event.dart';
part 'blog_posts_list_state.dart';

class BlogPostsListBloc extends Bloc<BlogPostsListEvent, BlogPostsListState> {
  BlogPostsListBloc({
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(BlogPostsListLoading()) {
    add(_BlogPostAuthUpdated(authenticationBloc.state));
    _authSubscription = authenticationBloc.stream.listen((authState) {
      add(_BlogPostAuthUpdated(authState));
    });
  }

  late final StreamSubscription _authSubscription;
  final BlogRepository _blogRepository;
  bool _isAuth = false;
  String? _userId;

  late DocumentSnapshot _lastFetchedDoc;

  final int _limit = 12;

  @override
  Future<void> close() {
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
      log('error' + e.toString());
      yield BlogPostsListFail();
    }
  }

  Stream<BlogPostsListState> _mapLoadMoreToState() async* {
    if (this.state is BlogPostsListLoadSuccess) {
      final oldState = state as BlogPostsListLoadSuccess;

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

  List<BlogPost> _mapQuerySnapshotToBlogPosts(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      BlogPost blog = BlogPost.fromEntity(BlogPostEntity.fromDocumentSnapshot(e));

      if (_isAuth) {
        blog = blog.copyWith(
          isAuthor: _userId! == blog.authorId,
          isUpliked: false, //TODO with hydrated bloc
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
}
