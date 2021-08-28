part of 'blog_post_delete_bloc.dart';

abstract class BlogPostDeleteState extends Equatable {
  const BlogPostDeleteState(
    this.blogId,
  );
  final String blogId;

  @override
  List<Object> get props => [blogId];
}

class BlogPostDeleteInitial extends BlogPostDeleteState {
  BlogPostDeleteInitial(String blogId) : super(blogId);
}

class BlogPostDeleteLoading extends BlogPostDeleteState {
  BlogPostDeleteLoading(String blogId) : super(blogId);
}

class BlogPostDeleteSuccess extends BlogPostDeleteState {
  BlogPostDeleteSuccess(String blogId) : super(blogId);
}

class BlogPostDeleteFail extends BlogPostDeleteState {
  BlogPostDeleteFail(String blogId) : super(blogId);
}
