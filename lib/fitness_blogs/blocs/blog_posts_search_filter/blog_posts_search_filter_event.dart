part of 'blog_posts_search_filter_bloc.dart';

abstract class BlogPostsSearchFilterEvent extends Equatable {
  const BlogPostsSearchFilterEvent();

  @override
  List<Object?> get props => [];
}

class BlogPostsSearchFilterUpdated extends BlogPostsSearchFilterEvent {
  final BlogSearchResult? result;

  const BlogPostsSearchFilterUpdated(this.result);

  @override
  List<Object?> get props => [result];
}

class BlogPostsSearchFilterClearRequested extends BlogPostsSearchFilterEvent {}
