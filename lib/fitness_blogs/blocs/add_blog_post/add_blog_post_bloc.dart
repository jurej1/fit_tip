import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'add_blog_post_event.dart';
part 'add_blog_post_state.dart';

class AddBlogPostBloc extends Bloc<AddBlogPostEvent, AddBlogPostState> {
  AddBlogPostBloc({
    required UserDataBloc userDataBloc,
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(AddBlogPostState.initial(userDataBloc.state.user)) {
    _userSubscription = userDataBloc.stream.listen((userState) {
      add(_AddBlogPostUserUpdated(userState.user));
    });
  }

  late final StreamSubscription _userSubscription;
  final BlogRepository _blogRepository;

  @override
  Future<void> close() {
    _userSubscription.cancel();
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
      yield* _mapTagFieldUpdatedToState(event);
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
        state.author,
        state.title,
      ]),
    );
  }

  Stream<AddBlogPostState> _mapBannerUpdatedToState(AddBlogPostBannerUpdated event) async* {
    if (event.value != null) {
      final banner = BlogBanner.dirty(File(event.value!.path));

      yield state.copyWith(
        banner: banner,
        status: Formz.validate(
          [
            banner,
            state.tags,
            state.content,
            state.title,
            state.author,
          ],
        ),
      );
    }
  }

  Stream<AddBlogPostState> _mapTagAddedToState(AddBlogPostTagAdded event) async* {
    if (!state.tags.value.contains(state.tagField) && state.tagField != null) {
      List<String> tags = List<String>.from(state.tags.value)..add(state.tagField!);

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
    } else {
      yield state.copyWith(tagField: '');
    }
  }

  Stream<AddBlogPostState> _mapTagRemovedToState(AddBlogPostTagRemoved event) async* {
    final tags = List<String>.from(state.tags.value)..removeWhere(((element) => element == event.value));

    final blogTags = BlogTags.dirty(tags);

    log(tags.toString());

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

    if (state.status.isValidated && state.userId != null) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        BlogPost blog = BlogPost.empty().copyWith(
          authorId: state.userId,
          content: state.content.value,
          isPublic: state.isPublic,
          title: state.title.value,
          author: state.author.value,
          tags: state.tags.value,
          isAuthor: true,
        );

        if (state.banner.value != null) {
          String? downloadUrl = await _blogRepository.uploadBlogBanner(state.banner.value!, state.userId!);

          blog = blog.copyWith(
            bannerUrl: downloadUrl,
          );
        }
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
      userId: event.value?.id,
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

  Stream<AddBlogPostState> _mapTagFieldUpdatedToState(AddBlogPostTagFieldUpdated event) async* {
    yield state.copyWith(tagField: event.value);

    if (state.tagField?.endsWith('') ?? false) {
      log('ends with space');
      add(AddBlogPostTagAdded());
    }
  }
}
