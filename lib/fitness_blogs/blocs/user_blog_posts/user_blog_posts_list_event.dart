part of 'user_blog_posts_list_bloc.dart';

abstract class UserBlogPostsListEvent extends Equatable {
  const UserBlogPostsListEvent();

  @override
  List<Object?> get props => [];
}

class UserBlogPostsListLoadRequested extends UserBlogPostsListEvent {
  final String? userId;
  final List<String> likedBlogs;
  final List<String> savedBlogs;

  const UserBlogPostsListLoadRequested({
    required this.userId,
    required this.likedBlogs,
    required this.savedBlogs,
  });

  @override
  List<Object?> get props => [userId, savedBlogs, likedBlogs];
}

class UserBlogPostsListLoadMoreRequested extends UserBlogPostsListEvent {
  final String? userId;
  final List<String> likedBlogs;
  final List<String> savedBlogs;

  const UserBlogPostsListLoadMoreRequested({required this.userId, required this.likedBlogs, required this.savedBlogs});

  @override
  List<Object?> get props => [userId, savedBlogs, likedBlogs];
}

class UserBlogPostsListItemAdded extends UserBlogPostsListEvent {
  final BlogPost blog;
  final String? userId;

  const UserBlogPostsListItemAdded(
    this.blog,
    this.userId,
  );

  @override
  List<Object?> get props => [blog, userId];
}

class UserBlogPostsListItemUpdated extends UserBlogPostsListEvent {
  final BlogPost blog;
  final String? userId;

  const UserBlogPostsListItemUpdated(this.blog, this.userId);

  @override
  List<Object?> get props => [blog];
}

class UserBlogPostsListItemRemoved extends UserBlogPostsListEvent {
  final BlogPost blog;

  const UserBlogPostsListItemRemoved(this.blog);

  @override
  List<Object?> get props => [blog];
}
