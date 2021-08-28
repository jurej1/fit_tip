part of 'about_author_bloc.dart';

abstract class AboutAuthorState extends Equatable {
  const AboutAuthorState();

  @override
  List<Object> get props => [];
}

class AboutAuthorLoading extends AboutAuthorState {}

class AboutAuthorLoadSuccess extends AboutAuthorState {
  final User author;

  const AboutAuthorLoadSuccess(this.author);

  @override
  List<Object> get props => [author];
}

class AboutAuthorFail extends AboutAuthorState {}
