part of 'user_blog_posts_list_bloc.dart';

abstract class UserBlogPostsListEvent extends Equatable {
  const UserBlogPostsListEvent();

  @override
  List<Object?> get props => [];
}

class UserBlogPostsListLoadRequested extends UserBlogPostsListEvent {
  final String? userId;

  const UserBlogPostsListLoadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UserBlogPostsListLoadMoreRequested extends UserBlogPostsListEvent {
  final String? userId;

  const UserBlogPostsListLoadMoreRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
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

  const UserBlogPostsListItemUpdated(this.blog);

  @override
  List<Object?> get props => [blog];
}

class UserBlogPostsListItemRemoved extends UserBlogPostsListEvent {
  final BlogPost blog;

  const UserBlogPostsListItemRemoved(this.blog);

  @override
  List<Object?> get props => [blog];
}
