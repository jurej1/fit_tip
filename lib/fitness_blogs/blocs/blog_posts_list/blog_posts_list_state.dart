part of 'blog_posts_list_bloc.dart';

abstract class BlogPostsListState extends Equatable {
  const BlogPostsListState();

  @override
  List<Object> get props => [];
}

class BlogPostsListLoading extends BlogPostsListState {}

class BlogPostsListLoadSuccess extends BlogPostsListState {
  final List<BlogPost> blogs;
  final bool hasReachedMax;

  const BlogPostsListLoadSuccess({
    this.blogs = const [],
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [blogs, hasReachedMax];
}

class BlogPostsListFail extends BlogPostsListState {}
