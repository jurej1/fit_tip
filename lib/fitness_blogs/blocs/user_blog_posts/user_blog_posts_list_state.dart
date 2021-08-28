part of 'user_blog_posts_list_bloc.dart';

abstract class UserBlogPostsListState extends Equatable {
  const UserBlogPostsListState();

  @override
  List<Object> get props => [];
}

class UserBlogPostsListLoading extends UserBlogPostsListState {}

class UserBlogPostsListLoadSuccess extends UserBlogPostsListState {
  final List<BlogPost> blogs;
  final bool hasReachedMax;

  const UserBlogPostsListLoadSuccess({
    required this.blogs,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [blogs, hasReachedMax];
}

class UserBlogPostsListFail extends UserBlogPostsListState {}
