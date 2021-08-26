part of 'saved_blog_posts_bloc.dart';

abstract class SavedBlogPostsEvent extends Equatable {
  const SavedBlogPostsEvent();

  @override
  List<Object> get props => [];
}

class SavedBlogPostsItemAdded extends SavedBlogPostsEvent {
  final String blogId;

  const SavedBlogPostsItemAdded(this.blogId);

  @override
  List<Object> get props => [blogId];
}

class SavedBlogPostsItemRemoved extends SavedBlogPostsEvent {
  final String blogId;

  const SavedBlogPostsItemRemoved(this.blogId);

  @override
  List<Object> get props => [blogId];
}

class _SavedBlogPostsAuthUpdated extends SavedBlogPostsEvent {}
