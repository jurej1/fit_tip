import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';

part 'blog_posts_saved_list_event.dart';
part 'blog_posts_saved_list_state.dart';

class BlogPostsSavedListBloc extends Bloc<BlogPostsSavedListEvent, BlogPostsSavedListState> {
  BlogPostsSavedListBloc() : super(BlogPostsSavedListLoading());

  @override
  Stream<BlogPostsSavedListState> mapEventToState(
    BlogPostsSavedListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
