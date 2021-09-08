import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_card_event.dart';

class BlogPostCardBloc extends Bloc<BlogPostCardEvent, BlogPost> {
  BlogPostCardBloc({required BlogPost blogPost}) : super(blogPost);

  @override
  Stream<BlogPost> mapEventToState(
    BlogPostCardEvent event,
  ) async* {
    if (event is BlogPostCardItemUpdated) {
      yield event.blogPost;
    } else if (event is BlogPostCardLiked) {
      yield state.copyWith(like: event.like);
    } else if (event is BlogPostCardSaved) {
      yield state.copyWith(isSaved: event.isSaved);
    }
  }
}
