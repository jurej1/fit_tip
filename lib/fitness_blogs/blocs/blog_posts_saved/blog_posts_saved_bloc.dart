import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

class BlogPostsSavedBloc extends BlogPostsBaseBloc {
  BlogPostsSavedBloc({
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
  })  : _authenticationBloc = authenticationBloc,
        _blogRepository = blogRepository,
        super(
          BlogPostsLoading(),
          authenticationBloc: authenticationBloc,
          blogRepository: blogRepository,
        );

  final AuthenticationBloc _authenticationBloc;
  final BlogRepository _blogRepository;

  final int _limit = 12;
  DocumentSnapshot? _lastDocumentSnapshot;

  @override
  Stream<BlogPostsBaseState> mapLoadMoreRequestedToState(BlogPostsLoadMoreRequested event) async* {
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
          startAfterDoc: _lastDocumentSnapshot,
        );

        if (snapshot.docs.isEmpty) {
          yield BlogPostsLoadSuccess(blogPosts, snapshot.docs.length < _limit);
        } else {
          _lastDocumentSnapshot = snapshot.docs.last;

          blogPosts = blogPosts + mapQuerySnapshotToList(snapshot);
          yield BlogPostsLoadSuccess(
            blogPosts,
            snapshot.size < _limit,
          );
        }
      } catch (error) {
        yield BlogPostsFail();
      }
    }
  }

  @override
  Stream<BlogPostsBaseState> mapLoadRequestedToState(BlogPostsLoadRequested event) async* {
    if (_authenticationBloc.state.isAuthenticated == false) {
      yield BlogPostsFail();
      return;
    }

    List<BlogPost> blogs = const [];
    List<String> savedBlogIds = List<String>.from(_blogRepository.getSavedBlogIds(_authenticationBloc.state.user!.uid!));

    if (state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;
      blogs = oldState.blogPosts;
      savedBlogIds = _mapBlogPostsToNotFetchedBlogIds(savedBlogIds, blogs);
    }

    if (savedBlogIds.isEmpty) {
      yield BlogPostsLoadSuccess([], true);
      return;
    }

    yield BlogPostsLoading();

    try {
      QuerySnapshot querySnapshot = await _blogRepository.getBlogPostsByBlogIds(
        limit: _limit,
        blogIds: savedBlogIds,
      );

      if (querySnapshot.docs.isEmpty) {
        yield BlogPostsLoadSuccess(blogs, querySnapshot.docs.length < _limit);
      } else {
        _lastDocumentSnapshot = querySnapshot.docs.last;

        blogs = blogs +
            BlogPost.mapQuerySnapshotToBlogPosts(
              querySnapshot,
              userId: _authenticationBloc.state.user?.uid,
              saveBlogIds: savedBlogIds,
              likedBlogIds: _blogRepository.getLikedBlogIds(_authenticationBloc.state.user!.uid!),
            );

        yield BlogPostsLoadSuccess(
          blogs,
          querySnapshot.docs.length < _limit,
        );
      }
    } catch (error) {
      yield BlogPostsFail();
    }
  }

  List<String> _mapBlogPostsToNotFetchedBlogIds(List<String> savedBlogIds, List<BlogPost> posts) {
    return List<String>.from(savedBlogIds)..removeWhere((savedId) => posts.any((element) => element.id == savedId));
  }
}
