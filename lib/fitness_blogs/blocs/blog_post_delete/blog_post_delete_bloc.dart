import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_post_delete_event.dart';
part 'blog_post_delete_state.dart';

class BlogPostDeleteBloc extends Bloc<BlogPostDeleteEvent, BlogPostDeleteState> {
  BlogPostDeleteBloc({
    required String blogId,
    required bool isAuthor,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(BlogPostDeleteInitial(blogId, isAuthor));

  final BlogRepository _blogRepository;

  @override
  Stream<BlogPostDeleteState> mapEventToState(
    BlogPostDeleteEvent event,
  ) async* {
    if (event is BlogPostDeleteRequested) {
      yield* _mapDeleteRequestedToState(event);
    }
  }

  Stream<BlogPostDeleteState> _mapDeleteRequestedToState(BlogPostDeleteRequested event) async* {
    yield BlogPostDeleteLoading(state.blogId, state.isAuthor);

    try {
      if (state.isAuthor) {
        await _blogRepository.deleteBlogPost(state.blogId);

        yield BlogPostDeleteSuccess(state.blogId, state.isAuthor);
      } else {
        yield BlogPostDeleteFail(state.blogId, state.isAuthor);
      }
    } catch (error) {
      yield BlogPostDeleteFail(state.blogId, state.isAuthor);
    }
  }
}
