import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        super(AddBlogPostState.initial(authenticationBloc.state.user)) {
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
      yield* _mapUserUpdatedToState(event);
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
    } else if (event is AddBlogPostPublicPressed) {
      yield state.copyWith(isPublic: !state.isPublic);
    } else if (event is AddBlogPostTagFieldUpdated) {
      yield state.copyWith(tagField: event.value);
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
        state.author,
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
        state.author,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapBannerUpdatedToState(AddBlogPostBannerUpdated event) async* {
    //TODO
  }

  Stream<AddBlogPostState> _mapTagAddedToState(AddBlogPostTagAdded event) async* {
    List<String> tags = List<String>.from(state.tags.value)
      ..add(state.tagField)
      ..toSet().toList();

    final blogTags = BlogTags.dirty(tags);

    yield state.copyWith(
      tags: blogTags,
      tagField: '',
      status: Formz.validate([
        blogTags,
        state.banner,
        state.content,
        state.title,
        state.author,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapTagRemovedToState(AddBlogPostTagRemoved event) async* {
    final tags = state.tags.value..where((element) => element == event.value);

    final blogTags = BlogTags.dirty(tags);

    yield state.copyWith(
      tags: blogTags,
      status: Formz.validate([
        blogTags,
        state.banner,
        state.content,
        state.title,
        state.author,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapSubmitToState(AddBlogPostSubmit event) async* {
    final author = BlogAuthor.dirty(state.author.value);
    final banner = BlogBanner.dirty(state.banner.value);
    final content = BlogContent.dirty(state.content.value);
    final tags = BlogTags.dirty(state.tags.value);
    final title = BlogTitle.dirty(state.title.value);

    yield state.copyWith(
      author: author,
      banner: banner,
      content: content,
      tags: tags,
      title: title,
      status: Formz.validate([
        author,
        banner,
        content,
        tags,
        title,
      ]),
    );

    if (state.status.isValidated && state.user != null) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        BlogPost blog = BlogPost(
          authorId: state.user!.id!,
          content: state.content.value,
          id: '',
          isPublic: state.isPublic,
          title: state.title.value,
          author: state.author.value,
          tags: state.tags.value,
          isAuthor: true,
        );

        DocumentReference ref = await _blogRepository.addBlogPost(blog);

        blog = blog.copyWith(id: ref.id);

        yield state.copyWith(blogPost: blog, status: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Stream<AddBlogPostState> _mapUserUpdatedToState(_AddBlogPostUserUpdated event) async* {
    final author = BlogAuthor.dirty(event.value?.displayName);
    yield state.copyWith(
      user: event.value,
      author: author,
      status: Formz.validate([
        author,
        state.banner,
        state.content,
        state.tags,
        state.title,
      ]),
    );
  }
}
