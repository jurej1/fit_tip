part of 'blog_post_like_cubit.dart';

abstract class BlogPostLikeState extends Equatable {
  final Like like;
  final int likesAmount;
  const BlogPostLikeState(this.like, this.likesAmount);

  @override
  List<Object?> get props => [like, likesAmount];
}

class BlogPostLikeInitial extends BlogPostLikeState {
  BlogPostLikeInitial(Like like, int likesAmount) : super(like, likesAmount);
}

class BlogPostLikeLoading extends BlogPostLikeState {
  BlogPostLikeLoading(Like like, int likesAmount) : super(like, likesAmount);
}

class BlogPostLikeSuccess extends BlogPostLikeState {
  BlogPostLikeSuccess(Like like, int likesAmount) : super(like, likesAmount);
}

class BlogPostLikeFail extends BlogPostLikeState {
  BlogPostLikeFail(Like like, int likesAmount) : super(like, likesAmount);
}
