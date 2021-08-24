import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc({required AuthenticationBloc authenticationBloc, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(UserDataState(null)) {
    add(_UserDataAuthStateUpdated(authenticationBloc.state));
    _authenticationSubscription = authenticationBloc.stream.listen((authEvent) => add(_UserDataAuthStateUpdated(authEvent)));
  }
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription _authenticationSubscription;
  StreamSubscription? _userSubscription;

  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UserDataState> mapEventToState(
    UserDataEvent event,
  ) async* {
    if (event is _UserDataAuthStateUpdated) {
      if (event.state.isAuthenticated) {
        _userSubscription = _authenticationRepository.user(event.state.user!.uid).listen((event) {
          add(UserDataUserUpdated(event));
        });
      } else {
        _userSubscription?.cancel();
      }
    } else if (event is UserDataUserUpdated) {
      yield state.copyWith(user: event.user);
    }
  }
}
