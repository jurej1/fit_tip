part of 'blog_posts_list_bloc.dart';

abstract class BlogPostsListEvent extends Equatable {
  const BlogPostsListEvent();

  @override
  List<Object?> get props => [];
}

class _BlogPostsListSavedBlogsUpdated extends BlogPostsListEvent {
  final List<String> ids;

  const _BlogPostsListSavedBlogsUpdated(this.ids);

  @override
  List<Object?> get props => [ids];
}

class _BlogPostsListLikedBlogsUpdated extends BlogPostsListEvent {
  final List<String> ids;

  const _BlogPostsListLikedBlogsUpdated(this.ids);

  @override
  List<Object?> get props => [ids];
}

class BlogPostsListLoadRequested extends BlogPostsListEvent {
  final List<String> likedBlogs;
  final List<String> savedBlogs;
  final String? userId;

  const BlogPostsListLoadRequested({
    this.likedBlogs = const [],
    this.savedBlogs = const [],
    this.userId,
  });

  @override
  List<Object?> get props => [userId, likedBlogs, savedBlogs];
}

class BlogPostsListLoadMore extends BlogPostsListEvent {
  final List<String> likedBlogs;
  final List<String> savedBlogs;
  final String? userId;

  const BlogPostsListLoadMore({
    this.likedBlogs = const [],
    this.savedBlogs = const [],
    this.userId,
  });
}

class BlogPostsListItemAdded extends BlogPostsListEvent {
  final BlogPost value;

  const BlogPostsListItemAdded(this.value);

  @override
  List<Object> get props => [value];
}

class BlogPostsListItemRemoved extends BlogPostsListEvent {
  final BlogPost value;

  const BlogPostsListItemRemoved(this.value);

  @override
  List<Object> get props => [value];
}

class BlogPostsListItemUpdated extends BlogPostsListEvent {
  final BlogPost value;

  const BlogPostsListItemUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class BlogPostsListBlogSearchClosed extends BlogPostsListEvent {
  final BlogSearchResult? result;

  const BlogPostsListBlogSearchClosed(this.result);

  @override
  List<Object?> get props => [result];
}
