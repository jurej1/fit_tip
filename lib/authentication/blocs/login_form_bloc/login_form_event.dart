part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginFormEvent {
  final String value;

  const LoginEmailChanged(this.value);

  @override
  List<Object> get props => [value];
}

class LoginEmailUnfocused extends LoginFormEvent {}

class LoginPasswordChanged extends LoginFormEvent {
  final String value;

  const LoginPasswordChanged(this.value);
  @override
  List<Object> get props => [value];
}

class LoginPasswordUnfocused extends LoginFormEvent {}

class LoginFormSubmit extends LoginFormEvent {}
