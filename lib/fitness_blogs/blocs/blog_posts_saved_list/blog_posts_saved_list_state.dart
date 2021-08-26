part of 'blog_posts_saved_list_bloc.dart';

abstract class BlogPostsSavedListState extends Equatable {
  const BlogPostsSavedListState();

  @override
  List<Object> get props => [];
}

class BlogPostsSavedListLoading extends BlogPostsSavedListState {}

class BlogPostsSavedListLoadSuccess extends BlogPostsSavedListState {
  final List<BlogPost> blogs;

  const BlogPostsSavedListLoadSuccess(this.blogs);

  @override
  List<Object> get props => [blogs];
}

class BlogPostsSavedListFailure extends BlogPostsSavedListState {}
