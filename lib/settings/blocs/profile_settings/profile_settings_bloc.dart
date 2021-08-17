import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:fit_tip/settings/models/models.dart';
import 'package:formz/formz.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc({
    required AuthenticationBloc authenticationBloc,
  }) : super(
          ProfileSettingsState.fromUser(authenticationBloc.state.user),
        ) {
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
    if (event is _ProfileSettingsUserUpdated) {
      yield state.copyWith(
        authenticationStatus: AuthenticationStatus.authenticated,
        user: event.user,
      );
    } else if (event is ProfileSettingsEditButtonPressed) {
      yield* _mapButtonPressedToState();
    } else if (event is ProfileSettingsBirthdayUpdated) {
      yield* _mapBirthdayUpdatedToState(event);
    } else if (event is ProfileSettingsDisplayNameUpdated) {
      yield* _mapDisplayNameUpdatedToState(event);
    } else if (event is ProfileSettingsGenderUpdated) {
      yield* _mapGenderUpdatedToState(event);
    } else if (event is ProfileSettingsHeightUpdated) {
      yield* _mapHeightUpdatedToState(event);
    } else if (event is ProfileSettingsIntroductionLineUpdated) {
      yield* _mapIntroductionLineUpdatedToState(event);
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

  Stream<ProfileSettingsState> _mapBirthdayUpdatedToState(ProfileSettingsBirthdayUpdated event) async* {
    if (state.isEditMode) {
      final birthdayInput = BirthdayInput.dirty(event.value);
      yield state.copyWith(
        birthday: birthdayInput,
        status: Formz.validate(
          [
            birthdayInput,
            state.displayName,
            state.gender,
            state.height,
            state.introductionLine,
          ],
        ),
      );
    }
  }

  Stream<ProfileSettingsState> _mapDisplayNameUpdatedToState(ProfileSettingsDisplayNameUpdated event) async* {
    if (state.isEditMode) {
      final displayNameInput = DisplayNameInput.dirty(event.value);

      yield state.copyWith(
          displayName: displayNameInput,
          status: Formz.validate([
            displayNameInput,
            state.birthday,
            state.gender,
            state.height,
            state.introductionLine,
          ]));
    }
  }

  Stream<ProfileSettingsState> _mapGenderUpdatedToState(ProfileSettingsGenderUpdated event) async* {
    if (state.isEditMode && event.value != null) {
      final gender = GenderInput.dirty(event.value!);

      yield state.copyWith(
        gender: gender,
        status: Formz.validate([
          gender,
          state.birthday,
          state.displayName,
          state.height,
          state.introductionLine,
        ]),
      );
    }
  }

  Stream<ProfileSettingsState> _mapHeightUpdatedToState(ProfileSettingsHeightUpdated event) async* {
    if (state.isEditMode && event.value != null) {
      final heightInput = HeightInput.dirty(event.value.toString());

      yield state.copyWith(
        height: heightInput,
        status: Formz.validate(
          [
            heightInput,
            state.gender,
            state.birthday,
            state.displayName,
            state.introductionLine,
          ],
        ),
      );
    }
  }

  Stream<ProfileSettingsState> _mapIntroductionLineUpdatedToState(ProfileSettingsIntroductionLineUpdated event) async* {
    if (state.isEditMode) {
      final introductionLine = IntroductionLineInput.dirty(event.value);

      yield state.copyWith(
        introductionLine: introductionLine,
        status: Formz.validate(
          [
            introductionLine,
            state.birthday,
            state.height,
            state.gender,
            state.displayName,
          ],
        ),
      );
    }
  }
}
