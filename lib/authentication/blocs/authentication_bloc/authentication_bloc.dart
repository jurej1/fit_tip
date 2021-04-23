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
    _statusSubscription = _authenticationRepository.authenticationStatus.listen((status) => add(_StatusUpdated(status)));
  }

  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription _statusSubscription;
  StreamSubscription? _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is _StatusUpdated) {
      if (event.status == AuthenticationStatus.authenticated) {
        yield state.copyWith(status: event.status);

        _userSubscription = _authenticationRepository.user?.listen((user) => add(_UserUpdated(user)));
      } else if (event.status == AuthenticationStatus.unauthenticated) {
        yield state.copyWith(status: event.status, user: null);
        _userSubscription?.cancel();
      }
    } else if (event is _UserUpdated) {
      yield state.copyWith(user: event.user);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _statusSubscription.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
