part of 'blog_posts_saved_list_bloc.dart';

abstract class BlogPostsSavedListEvent extends Equatable {
  const BlogPostsSavedListEvent();

  @override
  List<Object?> get props => [];
}

class BlogPostsSavedListLoadRequested extends BlogPostsSavedListEvent {
  final List<String> savedBlogIds;
  final String? userId;
  final List<String> likedBlogIds;

  const BlogPostsSavedListLoadRequested({
    this.savedBlogIds = const [],
    this.userId,
    this.likedBlogIds = const [],
  });

  @override
  List<Object?> get props => [
        userId,
        savedBlogIds,
        likedBlogIds,
      ];
}

class BlogPostsSavedListLoadMoreRequested extends BlogPostsSavedListEvent {
  final List<String> savedBlogIds;
  final String? userId;
  final List<String> likedBlogIds;

  const BlogPostsSavedListLoadMoreRequested({
    this.savedBlogIds = const [],
    this.userId,
    this.likedBlogIds = const [],
  });
  @override
  List<Object?> get props => [
        userId,
        savedBlogIds,
        likedBlogIds,
      ];
}

class BlogPostsSavedListItemAdded extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemAdded(this.blog);

  @override
  List<Object> get props => [blog];
}

class BlogPostsSavedListItemUpdated extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemUpdated(this.blog);

  @override
  List<Object> get props => [blog];
}

class BlogPostsSavedListItemRemoved extends BlogPostsSavedListEvent {
  final BlogPost blog;

  const BlogPostsSavedListItemRemoved(this.blog);

  @override
  List<Object> get props => [blog];
}
