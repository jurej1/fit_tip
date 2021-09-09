import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';

class BlogPostsListBloc extends BlogPostsBaseBloc {
  BlogPostsListBloc({
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
    required BlogPostsSearchFilterBloc blogPostsSearchFilterBloc,
  })  : _blogRepository = blogRepository,
        _searchFilterBloc = blogPostsSearchFilterBloc,
        super(
          BlogPostsLoading(),
          authenticationBloc: authenticationBloc,
          blogRepository: blogRepository,
        );

  final BlogRepository _blogRepository;
  DocumentSnapshot? _lastFetchedDocument;
  final BlogPostsSearchFilterBloc _searchFilterBloc;

  final int _limit = 12;

  @override
  Stream<BlogPostsBaseState> mapLoadRequestedToState(BlogPostsLoadRequested event) async* {
    yield BlogPostsLoading();

    try {
      QuerySnapshot snapshot = await _mapSearchFilterToQuerySnapshot();

      if (snapshot.size == 0) {
        yield BlogPostsLoadSuccess([], true);
        return;
      } else {
        _lastFetchedDocument = snapshot.docs.last;

        List<BlogPost> blogs = mapQuerySnapshotToList(snapshot);

        yield BlogPostsLoadSuccess(
          blogs,
          snapshot.docs.length < _limit,
        );
      }
    } catch (e) {
      yield BlogPostsFail();
    }
  }

  @override
  Stream<BlogPostsBaseState> mapLoadMoreRequestedToState(BlogPostsLoadMoreRequested event) async* {
    if (this.state is BlogPostsLoadSuccess) {
      final oldState = state as BlogPostsLoadSuccess;

      if (!oldState.hasReachedMax) {
        try {
          QuerySnapshot querySnapshot = await _mapSearchFilterToQuerySnapshot(lastFetchedDoc: _lastFetchedDocument);
          if (querySnapshot.docs.isEmpty) {
            yield BlogPostsLoadSuccess(oldState.blogPosts, true);
          } else {
            _lastFetchedDocument = querySnapshot.docs.last;

            List<BlogPost> blogs = mapQuerySnapshotToList(querySnapshot);

            yield BlogPostsLoadSuccess(oldState.blogPosts + blogs, querySnapshot.docs.length < _limit);
          }
        } catch (error) {
          yield BlogPostsFail();
        }
      }
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
