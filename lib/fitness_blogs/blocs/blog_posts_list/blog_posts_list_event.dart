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
  const BlogPostsListLoadRequested();
}

class BlogPostsListLoadMore extends BlogPostsListEvent {}

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
