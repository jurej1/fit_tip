part of 'about_author_bloc.dart';

abstract class AboutAuthorEvent extends Equatable {
  const AboutAuthorEvent();

  @override
  List<Object> get props => [];
}

class AboutAuthorLoadRequested extends AboutAuthorEvent {
  final String authorId;

  const AboutAuthorLoadRequested(this.authorId);

  @override
  List<Object> get props => [authorId];
}
