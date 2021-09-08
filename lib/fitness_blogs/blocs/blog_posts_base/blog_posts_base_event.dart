part of 'blog_posts_base_bloc.dart';

abstract class BlogPostsBaseEvent extends Equatable {
  const BlogPostsBaseEvent();

  @override
  List<Object> get props => [];
}

class BlogPostsLoadRequested extends BlogPostsBaseEvent {}

class BlogPostsLoadMoreRequested extends BlogPostsBaseEvent {}

class BlogPostsItemAdded extends BlogPostsBaseEvent {
  final BlogPost value;

  const BlogPostsItemAdded(this.value);
}

class BlogPostsItemRemoved extends BlogPostsBaseEvent {
  final BlogPost value;

  const BlogPostsItemRemoved(this.value);
}

class BlogPostsItemUpdated extends BlogPostsBaseEvent {
  final BlogPost value;

  const BlogPostsItemUpdated(this.value);
}
