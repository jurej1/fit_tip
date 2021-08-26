part of 'liked_blog_posts_bloc.dart';

abstract class LikedBlogPostsEvent extends Equatable {
  const LikedBlogPostsEvent();

  @override
  List<Object> get props => [];
}

class LikedBlogPostsItemAdded extends LikedBlogPostsEvent {
  final String id;

  const LikedBlogPostsItemAdded(this.id);

  @override
  List<Object> get props => [id];
}

class LikedBlogPostsItemRemoved extends LikedBlogPostsEvent {
  final String id;

  const LikedBlogPostsItemRemoved(this.id);

  @override
  List<Object> get props => [id];
}
