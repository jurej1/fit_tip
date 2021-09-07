part of 'blog_posts_saved_list_bloc.dart';

abstract class BlogPostsSavedListEvent extends Equatable {
  const BlogPostsSavedListEvent();

  @override
  List<Object?> get props => [];
}

class BlogPostsSavedListLoadRequested extends BlogPostsSavedListEvent {
  const BlogPostsSavedListLoadRequested();

  @override
  List<Object?> get props => [];
}

class BlogPostsSavedListLoadMoreRequested extends BlogPostsSavedListEvent {
  const BlogPostsSavedListLoadMoreRequested();
  @override
  List<Object?> get props => [];
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
