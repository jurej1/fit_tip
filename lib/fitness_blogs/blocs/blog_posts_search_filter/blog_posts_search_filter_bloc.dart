import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';

part 'blog_posts_search_filter_event.dart';

class BlogPostsSearchFilterBloc extends Bloc<BlogPostsSearchFilterEvent, BlogSearchResult?> {
  BlogPostsSearchFilterBloc() : super(null);

  @override
  Stream<BlogSearchResult?> mapEventToState(
    BlogPostsSearchFilterEvent event,
  ) async* {
    if (event is BlogPostsSearchFilterUpdated) {
      if (event.result != null) {
        yield event.result;
      }
    } else if (event is BlogPostsSearchFilterClearRequested) {
      yield null;
    }
  }
}
