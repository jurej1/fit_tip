part of 'blog_post_detail_bloc.dart';

abstract class BlogPostDetailState extends Equatable {
  const BlogPostDetailState(this.blogPost);
  final BlogPost blogPost;

  @override
  List<Object> get props => [blogPost];
}

class BlogPostDetailInitial extends BlogPostDetailState {
  const BlogPostDetailInitial(BlogPost blogPost) : super(blogPost);
}

class BlogPostDetailLoading extends BlogPostDetailState {
  const BlogPostDetailLoading(BlogPost blogPost) : super(blogPost);
}

class BlogPostDetailFailure extends BlogPostDetailState {
  const BlogPostDetailFailure(BlogPost blogPost) : super(blogPost);
}
