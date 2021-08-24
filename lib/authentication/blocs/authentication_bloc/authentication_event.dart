part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class _AuthenticationUserUpdated extends AuthenticationEvent {
  final AuthenticationUser? authenticationUser;

  const _AuthenticationUserUpdated(this.authenticationUser);

  @override
  List<Object?> get props => [authenticationUser];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
