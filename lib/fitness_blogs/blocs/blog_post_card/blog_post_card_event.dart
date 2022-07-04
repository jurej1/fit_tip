part of 'blog_post_card_bloc.dart';

abstract class BlogPostCardEvent extends Equatable {
  const BlogPostCardEvent();

  @override
  List<Object> get props => [];
}

class BlogPostCardItemUpdated extends BlogPostCardEvent {
  final BlogPost blogPost;

  const BlogPostCardItemUpdated(this.blogPost);

  @override
  List<Object> get props => [this.blogPost];
}

class BlogPostCardSaved extends BlogPostCardEvent {
  final bool isSaved;

  const BlogPostCardSaved(this.isSaved);

  @override
  List<Object> get props => [this.isSaved];
}

class BlogPostCardLiked extends BlogPostCardEvent {
  final Like like;
  final int likesAmount;

  const BlogPostCardLiked(this.like, this.likesAmount);

  @override
  List<Object> get props => [this.like, this.likesAmount];
}
