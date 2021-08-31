part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticationUser? user;

  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  bool get isAuthenticated {
    return status == AuthenticationStatus.authenticated && user != null;
  }

  @override
  List<Object?> get props => [status, user];

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    AuthenticationUser? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
