part of 'user_blog_posts_list_bloc.dart';

abstract class UserBlogPostsListEvent extends Equatable {
  const UserBlogPostsListEvent();

  @override
  List<Object?> get props => [];
}

class UserBlogPostsListLoadRequested extends UserBlogPostsListEvent {
  const UserBlogPostsListLoadRequested();

  @override
  List<Object?> get props => [];
}

class UserBlogPostsListLoadMoreRequested extends UserBlogPostsListEvent {
  const UserBlogPostsListLoadMoreRequested();

  @override
  List<Object?> get props => [];
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
