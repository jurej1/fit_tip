import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_detail_event.dart';
part 'blog_post_detail_state.dart';

class BlogPostDetailBloc extends Bloc<BlogPostDetailEvent, BlogPostDetailState> {
  BlogPostDetailBloc({
    required BlogPost blogPost,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(BlogPostDetailInitial(blogPost));

  final BlogRepository _blogRepository;

  @override
  Stream<BlogPostDetailState> mapEventToState(
    BlogPostDetailEvent event,
  ) async* {
    if (event is BlogPostDetailLikeUpdated) {
      final blogPost = state.blogPost;
      yield BlogPostDetailInitial(
        blogPost.copyWith(
          like: event.newLike,
          likes: event.newLikesAmount,
        ),
      );
    }
  }
}
