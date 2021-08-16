import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/blocs.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc({
    required AuthenticationBloc authenticationBloc,
  }) : super(ProfileSettingsState(status: authenticationBloc.state.status)) {
    _streamSubscription = authenticationBloc.stream.listen(
      (authState) {
        if (authState.isAuthenticated) {
          add(_ProfileSettingsUserUpdated(authState.user));
        } else {
          add(_ProfileSettingsUserFail());
        }
      },
    );
  }

  late final StreamSubscription _streamSubscription;

  @override
  Stream<ProfileSettingsState> mapEventToState(
    ProfileSettingsEvent event,
  ) async* {
    if (event is _ProfileSettingsUserFail) {
      yield ProfileSettingsState(status: AuthenticationStatus.unauthenticated);
    } else if (event is _ProfileSettingsUserUpdated) {
      yield state.copyWith(
        status: AuthenticationStatus.authenticated,
        user: event.user,
      );
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
