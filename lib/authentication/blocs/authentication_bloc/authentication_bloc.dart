import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })   : _authenticationRepository = authenticationRepository,
        super(AuthenticationState()) {
    statusSubscription = _authenticationRepository.authenticationStatus.listen((status) => add(_StatusUpdated(status)));
  }

  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription statusSubscription;
  late final StreamSubscription? userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is _StatusUpdated) {
      yield state.copyWith(status: event.status);

      if (event.status == AuthenticationStatus.authenticated) {
        userSubscription = _authenticationRepository.user?.listen((user) => add(_UserUpdated(user)));
      } else if (event.status == AuthenticationStatus.unauthenticated) {
        userSubscription?.cancel();
      }
    } else if (event is _UserUpdated) {
      yield state.copyWith(user: event.user);
    }
  }

  @override
  Future<void> close() {
    statusSubscription.cancel();
    userSubscription?.cancel();
    return super.close();
  }
}
