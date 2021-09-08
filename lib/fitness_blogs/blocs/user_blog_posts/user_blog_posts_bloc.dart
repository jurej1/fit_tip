import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

class UserBlogPostsBloc extends BlogPostsBaseBloc {
  UserBlogPostsBloc({
    required String? userId,
    required BlogRepository blogRepository,
    required AuthenticationBloc authenticationBloc,
  })  : this._userId = userId,
        _blogRepository = blogRepository,
        super(
          userId == null ? BlogPostsFail() : BlogPostsLoading(),
          authenticationBloc: authenticationBloc,
          blogRepository: blogRepository,
        );

  final BlogRepository _blogRepository;
  final String? _userId;
  DocumentSnapshot? _lastFetchedDoc;

  final int _limit = 12;

  @override
  Stream<BlogPostsBaseState> mapLoadRequestedToState(BlogPostsLoadRequested event) async* {
    if (_userId == null) {
      yield BlogPostsFail();
      return;
    }

    yield BlogPostsLoading();

    try {
      QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsByOwnerId(_userId!, limit: _limit);

      if (querySnapshot.docs.isEmpty) {
        yield BlogPostsLoadSuccess([], true);
      } else {
        _lastFetchedDoc = querySnapshot.docs.last;

        List<BlogPost> blogPosts = mapQuerySnapshotToList(querySnapshot);
        yield BlogPostsLoadSuccess(blogPosts, querySnapshot.docs.length < _limit);
      }
    } catch (error) {
      yield BlogPostsFail();
    }
  }

  @override
  Stream<BlogPostsBaseState> mapLoadMoreRequestedToState(BlogPostsLoadMoreRequested event) async* {
    if (_userId == null) {
      yield BlogPostsFail();
      return;
    }

    if (state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;

      if (!oldState.hasReachedMax) {
        QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsByOwnerId(_userId!, limit: _limit, startAfterDoc: _lastFetchedDoc);

        if (querySnapshot.docs.isEmpty) {
          yield BlogPostsLoadSuccess(oldState.blogPosts, true);
        } else {
          _lastFetchedDoc = querySnapshot.docs.last;

          List<BlogPost> blogPosts = mapQuerySnapshotToList(querySnapshot);
          yield BlogPostsLoadSuccess(oldState.blogPosts + blogPosts, querySnapshot.docs.length < _limit);
        }
      }
    }
  }
}
