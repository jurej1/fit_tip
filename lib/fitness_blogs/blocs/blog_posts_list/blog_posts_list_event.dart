part of 'blog_posts_list_bloc.dart';

abstract class BlogPostsListEvent extends Equatable {
  const BlogPostsListEvent();

  @override
  List<Object?> get props => [];
}

class BlogPostsListLoadRequested extends BlogPostsListEvent {}

class BlogPostsListLoadMore extends BlogPostsListEvent {}

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

class _BlogPostAuthUpdated extends BlogPostsListEvent {
  final AuthenticationState value;

  const _BlogPostAuthUpdated(this.value);

  @override
  List<Object> get props => [value];
}