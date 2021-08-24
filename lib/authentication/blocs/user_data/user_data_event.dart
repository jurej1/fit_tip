part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class _UserDataAuthStateUpdated extends UserDataEvent {
  final AuthenticationState state;

  const _UserDataAuthStateUpdated(this.state);

  @override
  List<Object> get props => [state];
}

class UserDataUserUpdated extends UserDataEvent {
  final User user;

  const UserDataUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
