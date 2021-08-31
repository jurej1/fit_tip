import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthenticationState()) {
    _statusSubscription = _authenticationRepository.authenticationUser.listen(
      (authenticationUser) => add(
        _AuthenticationUserUpdated(authenticationUser),
      ),
    );
  }

  @override
  void onTransition(Transition<AuthenticationEvent, AuthenticationState> transition) {
    super.onTransition(transition);
    log(transition.toString());
  }

  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription _statusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is _AuthenticationUserUpdated) {
      if (event.authenticationUser != null) {
        yield state.copyWith(status: AuthenticationStatus.authenticated, user: event.authenticationUser);
      } else if (event.authenticationUser == null) {
        yield state.copyWith(status: AuthenticationStatus.unauthenticated, user: event.authenticationUser);
      }
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _statusSubscription.cancel();
    return super.close();
  }
}
