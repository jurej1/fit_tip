import 'dart:async';
import 'dart:html';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'about_author_event.dart';
part 'about_author_state.dart';

class AboutAuthorBloc extends Bloc<AboutAuthorEvent, AboutAuthorState> {
  AboutAuthorBloc({
    required BlogRepository blogRepository,
  })  : _blogRepository = blogRepository,
        super(AboutAuthorLoading());

  final BlogRepository _blogRepository;

  @override
  Stream<AboutAuthorState> mapEventToState(
    AboutAuthorEvent event,
  ) async* {
    if (event is AboutAuthorLoadRequested) {
      yield* _mapLoadRequestedToState(event);
    }
  }

  Stream<AboutAuthorState> _mapLoadRequestedToState(AboutAuthorLoadRequested event) async* {
    yield AboutAuthorLoading();

    try {
      DocumentSnapshot documentSnapshot = await _blogRepository.getAuthorData(event.authorId);

      User author = User.fromEntity(UserEntity.fromDocumentSnapshot(documentSnapshot));

      yield AboutAuthorLoadSuccess(author);
    } catch (error) {
      yield AboutAuthorFail();
    }
  }
}
