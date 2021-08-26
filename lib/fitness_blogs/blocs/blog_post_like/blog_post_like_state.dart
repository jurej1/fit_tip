part of 'blog_post_like_cubit.dart';

abstract class BlogPostLikeState extends Equatable {
  final Like like;
  final String blogId;
  final int likesAmount;
  const BlogPostLikeState(
    this.like,
    this.likesAmount,
    this.blogId,
  );

  @override
  List<Object?> get props => [like, likesAmount, blogId];
}

class BlogPostLikeInitial extends BlogPostLikeState {
  BlogPostLikeInitial(Like like, int likesAmount, String blogId) : super(like, likesAmount, blogId);
}

class BlogPostLikeLoading extends BlogPostLikeState {
  BlogPostLikeLoading(Like like, int likesAmount, String blogId) : super(like, likesAmount, blogId);
}

class BlogPostLikeSuccess extends BlogPostLikeState {
  BlogPostLikeSuccess(Like like, int likesAmount, String blogId) : super(like, likesAmount, blogId);
}

class BlogPostLikeFail extends BlogPostLikeState {
  BlogPostLikeFail(Like like, int likesAmount, String blogId) : super(like, likesAmount, blogId);
}
