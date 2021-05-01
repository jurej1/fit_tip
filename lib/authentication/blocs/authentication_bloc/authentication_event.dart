part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class _StatusUpdated extends AuthenticationEvent {
  final AuthenticationStatus status;

  const _StatusUpdated(this.status);

  @override
  List<Object> get props => [status];
}

class _UserUpdated extends AuthenticationEvent {
  final User user;

  const _UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
