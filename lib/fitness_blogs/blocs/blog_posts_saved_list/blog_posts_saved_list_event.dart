part of 'blog_posts_saved_list_bloc.dart';

abstract class BlogPostsSavedListEvent extends Equatable {
  const BlogPostsSavedListEvent();

  @override
  List<Object> get props => [];
}

class BlogPostsSavedListLoadRequested extends BlogPostsListEvent {}

class BlogPostsSavedListLoadMoreRequested extends BlogPostsListEvent {}

class _BlogPostsSavedListSavedBlogsListUpdated extends BlogPostsSavedListEvent {
  final List<String> ids;

  const _BlogPostsSavedListSavedBlogsListUpdated(this.ids);

  @override
  List<Object> get props => [ids];
}

class BlogPostsSavedListItemAdded extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemAdded(this.blog);

  @override
  List<Object> get props => [blog];
}

class BlogPostsSavedListItemUpdated extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemUpdated(this.blog);

  @override
  List<Object> get props => [blog];
}

class BlogPostsSavedListItemRemoved extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemRemoved(this.blog);

  @override
  List<Object> get props => [blog];
}
