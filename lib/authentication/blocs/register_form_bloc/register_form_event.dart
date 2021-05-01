part of 'register_form_bloc.dart';

abstract class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterFormEvent {
  final String value;

  const RegisterEmailChanged(this.value);

  @override
  List<Object> get props => [value];
}

class RegisterEmailUnfocused extends RegisterFormEvent {}

class RegisterPasswordChanged extends RegisterFormEvent {
  final String value;

  const RegisterPasswordChanged(this.value);
  @override
  List<Object> get props => [value];
}

class RegisterPasswordUnfocused extends RegisterFormEvent {}

class RegisterFormSubmit extends RegisterFormEvent {}
