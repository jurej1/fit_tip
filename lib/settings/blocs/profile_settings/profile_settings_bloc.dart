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
  }) : super(
          ProfileSettingsState(status: authenticationBloc.state.status, mode: ProfileSettingsMode.look),
        ) {
    final authState = authenticationBloc.state;
    if (authState.isAuthenticated) {
      add(_ProfileSettingsUserUpdated(authState.user));
    } else {
      add(_ProfileSettingsUserFail());
    }

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
      yield ProfileSettingsState(status: AuthenticationStatus.unauthenticated, mode: state.mode);
    } else if (event is _ProfileSettingsUserUpdated) {
      yield state.copyWith(
        status: AuthenticationStatus.authenticated,
        user: event.user,
      );
    } else if (event is ProfileSettingsEditButtonPressed) {
      yield* _mapButtonPressedToState();
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<ProfileSettingsState> _mapButtonPressedToState() async* {
    if (state.mode == ProfileSettingsMode.look) {
      yield state.copyWith(mode: ProfileSettingsMode.edit);
    } else {
      yield state.copyWith(mode: ProfileSettingsMode.look);
    }
  }
}