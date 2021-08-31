part of 'blog_post_delete_bloc.dart';

abstract class BlogPostDeleteState extends Equatable {
  const BlogPostDeleteState(
    this.blogId,
    this.isAuthor,
  );
  final String blogId;
  final bool isAuthor;

  @override
  List<Object> get props => [blogId, isAuthor];
}

class BlogPostDeleteInitial extends BlogPostDeleteState {
  BlogPostDeleteInitial(String blogId, bool isAuthor) : super(blogId, isAuthor);
}

class BlogPostDeleteLoading extends BlogPostDeleteState {
  BlogPostDeleteLoading(String blogId, bool isAuthor) : super(blogId, isAuthor);
}

class BlogPostDeleteSuccess extends BlogPostDeleteState {
  BlogPostDeleteSuccess(String blogId, bool isAuthor) : super(blogId, isAuthor);
}

class BlogPostDeleteFail extends BlogPostDeleteState {
  BlogPostDeleteFail(String blogId, bool isAuthor) : super(blogId, isAuthor);
}
