part of 'blog_posts_saved_list_bloc.dart';

abstract class BlogPostsSavedListState extends Equatable {
  const BlogPostsSavedListState();

  @override
  List<Object> get props => [];
}

class BlogPostsSavedListLoading extends BlogPostsSavedListState {}

class BlogPostsSavedListLoadSuccess extends BlogPostsSavedListState {
  final List<BlogPost> blogs;
  final bool hasReachedMax;

  const BlogPostsSavedListLoadSuccess({
    required this.blogs,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [blogs];

  BlogPostsSavedListLoadSuccess copyWith({
    List<BlogPost>? blogs,
    bool? hasReachedMax,
  }) {
    return BlogPostsSavedListLoadSuccess(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class BlogPostsSavedListFailure extends BlogPostsSavedListState {}
