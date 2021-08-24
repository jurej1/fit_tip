import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:fit_tip/settings/models/models.dart';
import 'package:formz/formz.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc({
    required UserDataBloc userDataBloc,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(ProfileSettingsState.fromUser(userDataBloc.state.user)) {
    _streamSubscription = userDataBloc.stream.listen(
      (userData) {
        if (userData.user != null) {
          add(_ProfileSettingsUserUpdated(userData.user));
        } else {
          add(_ProfileSettingsUserFail());
        }
      },
    );
  }

  late final StreamSubscription _streamSubscription;
  final AuthenticationRepository _authenticationRepository;

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
    } else if (event is ProfileSettingsEmailUpdated) {
      yield* _mapEmailUpdatedToState(event);
    } else if (event is ProfileSettingsFormSubmit) {
      yield* _mapFormSubmitToState(event);
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
            state.email,
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
        status: Formz.validate(
          [
            displayNameInput,
            state.birthday,
            state.gender,
            state.height,
            state.introductionLine,
            state.email,
          ],
        ),
      );
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
          state.email,
        ]),
      );
    }
  }

  Stream<ProfileSettingsState> _mapHeightUpdatedToState(ProfileSettingsHeightUpdated event) async* {
    if (state.isEditMode && event.value != null) {
      final heightInput = HeightInput.dirty(event.value!.toDouble());

      yield state.copyWith(
        height: heightInput,
        status: Formz.validate(
          [
            heightInput,
            state.gender,
            state.birthday,
            state.displayName,
            state.introductionLine,
            state.email,
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
            state.email,
          ],
        ),
      );
    }
  }

  Stream<ProfileSettingsState> _mapEmailUpdatedToState(ProfileSettingsEmailUpdated event) async* {
    if (state.isEditMode) {
      final email = Email.dirty(event.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.introductionLine,
          state.birthday,
          state.height,
          state.gender,
          state.displayName,
        ]),
      );
    }
  }

  Stream<ProfileSettingsState> _mapFormSubmitToState(ProfileSettingsFormSubmit event) async* {
    if (state.isEditMode && state.authenticationStatus == AuthenticationStatus.authenticated) {
      final email = Email.dirty(state.email.value);
      final introductionLine = IntroductionLineInput.dirty(state.introductionLine.value);
      final birhtday = BirthdayInput.dirty(state.birthday.value);
      final height = HeightInput.dirty(state.height.value);
      final gender = GenderInput.dirty(state.gender.value);
      final displayName = DisplayNameInput.dirty(state.displayName.value);

      yield state.copyWith(
          status: Formz.validate([
        email,
        introductionLine,
        birhtday,
        height,
        gender,
        displayName,
      ]));

      if (state.status.isValidated) {
        try {
          yield state.copyWith(status: FormzStatus.submissionInProgress);

          await _authenticationRepository.updatedUserData(state.getNewUser()!);

          if (!state.email.pure) {
            await _authenticationRepository.updateUserEmail(state.email.value);
          }

          yield state.copyWith(status: FormzStatus.submissionSuccess, user: state.getNewUser(), mode: ProfileSettingsMode.look);
        } catch (error) {
          log(error.toString());
          yield state.copyWith(status: FormzStatus.submissionFailure);
        }
      }
    }
  }
}
