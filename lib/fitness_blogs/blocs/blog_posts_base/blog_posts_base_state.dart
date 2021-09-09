part of 'blog_posts_base_bloc.dart';

abstract class BlogPostsBaseState {
  const BlogPostsBaseState();
}

class BlogPostsLoading extends BlogPostsBaseState {}

class BlogPostsLoadSuccess extends BlogPostsBaseState {
  final List<BlogPost> blogPosts;
  final bool hasReachedMax;

  BlogPostsLoadSuccess(this.blogPosts, this.hasReachedMax);
}

class BlogPostsFail extends BlogPostsBaseState {}
