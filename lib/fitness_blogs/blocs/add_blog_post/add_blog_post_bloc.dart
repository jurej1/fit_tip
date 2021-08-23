import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:formz/formz.dart';

part 'add_blog_post_event.dart';
part 'add_blog_post_state.dart';

class AddBlogPostBloc extends Bloc<AddBlogPostEvent, AddBlogPostState> {
  AddBlogPostBloc() : super(AddBlogPostState());

  @override
  Stream<AddBlogPostState> mapEventToState(
    AddBlogPostEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
