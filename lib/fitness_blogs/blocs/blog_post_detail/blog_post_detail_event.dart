part of 'blog_post_detail_bloc.dart';

abstract class BlogPostDetailEvent extends Equatable {
  const BlogPostDetailEvent();

  @override
  List<Object> get props => [];
}

class BlogPostDetailLikeUpdated extends BlogPostDetailEvent {
  final Like newLike;
  final int newLikesAmount;

  const BlogPostDetailLikeUpdated(this.newLike, this.newLikesAmount);
  @override
  List<Object> get props => [
        newLike,
        newLikesAmount,
      ];
}
