import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'liked_blog_posts_event.dart';
part 'liked_blog_posts_state.dart';

class LikedBlogPostsBloc extends Bloc<LikedBlogPostsEvent, LikedBlogPostsState> {
  LikedBlogPostsBloc() : super(LikedBlogPostsInitial());

  @override
  Stream<LikedBlogPostsState> mapEventToState(
    LikedBlogPostsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
