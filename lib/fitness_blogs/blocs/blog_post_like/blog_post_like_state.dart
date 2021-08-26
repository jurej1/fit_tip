part of 'blog_post_like_cubit.dart';

abstract class BlogPostLikeState extends Equatable {
  final Like like;
  const BlogPostLikeState(this.like);

  @override
  List<Object?> get props => [like];
}

class BlogPostLikeInitial extends BlogPostLikeState {
  const BlogPostLikeInitial(Like like) : super(like);
}

class BlogPostLikeLoading extends BlogPostLikeState {
  const BlogPostLikeLoading(Like like) : super(like);
}

class BlogPostLikeSuccess extends BlogPostLikeState {
  const BlogPostLikeSuccess(Like like) : super(like);
}

class BlogPostLikeFail extends BlogPostLikeState {
  const BlogPostLikeFail(Like like) : super(like);
}
