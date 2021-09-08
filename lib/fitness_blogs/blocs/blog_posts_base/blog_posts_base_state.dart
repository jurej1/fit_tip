part of 'blog_posts_base_bloc.dart';

abstract class BlogPostsBaseState extends Equatable {
  const BlogPostsBaseState();

  @override
  List<Object> get props => [];
}

class BlogPostsLoading extends BlogPostsBaseState {}

class BlogPostsLoadSuccess extends BlogPostsBaseState {
  final List<BlogPost> blogPosts;
  final bool hasReachedMax;

  BlogPostsLoadSuccess(this.blogPosts, this.hasReachedMax);

  @override
  List<Object> get props => [blogPosts, hasReachedMax];
}

class BlogPostsFail extends BlogPostsBaseState {}
