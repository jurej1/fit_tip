import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:formz/formz.dart';

part 'add_blog_post_event.dart';
part 'add_blog_post_state.dart';

class AddBlogPostBloc extends Bloc<AddBlogPostEvent, AddBlogPostState> {
  AddBlogPostBloc({
    required AuthenticationBloc authenticationBloc,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(AddBlogPostState(user: authenticationBloc.state.user!)) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      add(_AddBlogPostUserUpdated(authState.user));
    });
  }

  late final StreamSubscription _authSubscription;
  final BlogRepository _blogRepository;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AddBlogPostState> mapEventToState(
    AddBlogPostEvent event,
  ) async* {
    if (event is _AddBlogPostUserUpdated) {
      if (event.value != null) {
        yield state.copyWith(user: event.value);
      }
    } else if (event is AddBlogPostTitleUpdated) {
      yield* _mapTitleUpdatedToState(event);
    } else if (event is AddBlogPostContentUpdated) {
      yield* _mapContentUpdatedToState(event);
    } else if (event is AddBlogPostBannerUpdated) {
      yield* _mapBannerUpdatedToState(event);
    } else if (event is AddBlogPostTagAdded) {
      yield* _mapTagAddedToState(event);
    } else if (event is AddBlogPostTagRemoved) {
      yield* _mapTagRemovedToState(event);
    } else if (event is AddBlogPostSubmit) {
      yield* _mapSubmitToState(event);
    }
  }

  Stream<AddBlogPostState> _mapTitleUpdatedToState(AddBlogPostTitleUpdated event) async* {
    final title = BlogTitle.dirty(event.value);

    yield state.copyWith(
      title: title,
      status: Formz.validate([
        title,
        state.banner,
        state.content,
        state.tags,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapContentUpdatedToState(AddBlogPostContentUpdated event) async* {
    final content = BlogContent.dirty(event.value);

    yield state.copyWith(
      content: content,
      status: Formz.validate([
        content,
        state.banner,
        state.tags,
        state.tags,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapBannerUpdatedToState(AddBlogPostBannerUpdated event) async* {
    //TODO
  }

  Stream<AddBlogPostState> _mapTagAddedToState(AddBlogPostTagAdded event) async* {
    final tags = state.tags.value..add(event.value);

    final blogTags = BlogTags.dirty(tags);

    yield state.copyWith(
      tags: blogTags,
      status: Formz.validate([
        blogTags,
        state.banner,
        state.content,
        state.title,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapTagRemovedToState(AddBlogPostTagRemoved event) async* {
    final tags = state.tags.value..removeWhere((element) => element == event.value);

    final blogTags = BlogTags.dirty(tags);

    yield state.copyWith(
      tags: blogTags,
      status: Formz.validate([
        blogTags,
        state.banner,
        state.content,
        state.title,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapSubmitToState(AddBlogPostSubmit event) async* {
    //TODO
  }
}
