import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/settings/models/birthday_input.dart';
import 'package:fit_tip/settings/models/gender_input.dart';
import 'package:fit_tip/settings/models/height_input.dart';
import 'package:fit_tip/settings/models/introduction_line_input.dart';
import 'package:formz/formz.dart';

part 'complete_account_form_event.dart';
part 'complete_account_form_state.dart';

class CompleteAccountFormBloc extends Bloc<CompleteAccountFormEvent, CompleteAccountFormState> {
  CompleteAccountFormBloc({
    required AuthenticationBloc authenticationBloc,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(CompleteAccountFormState.initial(authenticationBloc.state.user)) {
    _authSubscription = authenticationBloc.stream.listen((authState) {
      add(_CompleteAccountFormUserUpdated(authState.user));
    });
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription _authSubscription;

  bool get _isAuth => state.user != null;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<CompleteAccountFormState> mapEventToState(
    CompleteAccountFormEvent event,
  ) async* {
    if (event is CompleteAccountFormDisplayNameUpdated) {
      yield* _mapDisplayNameUpdatedToState(event);
    } else if (event is CompleteAccountFormBirthdateUpdated) {
      yield* _mapBirthdateUpdatedToState(event);
    } else if (event is CompleteAccountFormFirstNameUpdated) {
      yield* _mapFirstnameUpdatedToState(event);
    } else if (event is CompleteAccountFormLastNameUpdated) {
      yield* _mapLastNameUpdatedToState(event);
    } else if (event is CompleteAccountFormGenderUpdated) {
      yield* _mapGenderUpdatedToState(event);
    } else if (event is CompleteAccountFormIntroductionUpdated) {
      yield* _mapIntroductionUpdatedToState(event);
    } else if (event is CompleteAccountFormSubmit) {
      yield* _mapSubmitToState(event);
    } else if (event is _CompleteAccountFormUserUpdated) {
      yield CompleteAccountFormState.initial(event.user);
    } else if (event is CompleteAccountFormMeasurmentSystemUpdated) {
      yield* _mapMeasurmentSystemUpdatedToState(event);
    } else if (event is CompleteAccountFormHeightUpdated) {
      yield* _mapHeightUpdatedToState(event);
    }
  }

  Stream<CompleteAccountFormState> _mapDisplayNameUpdatedToState(CompleteAccountFormDisplayNameUpdated event) async* {
    final displayName = NameInput.dirty(event.value);
    yield state.copyWith(
      displayName: displayName,
      status: Formz.validate([
        displayName,
        state.birthday,
        state.firstName,
        state.gender,
        state.introduction,
        state.lastName,
        state.measurmentSystem,
        state.height,
      ]),
    );
  }

  Stream<CompleteAccountFormState> _mapBirthdateUpdatedToState(CompleteAccountFormBirthdateUpdated event) async* {
    final birthdate = BirthdayInput.dirty(event.value);

    yield state.copyWith(
      birthday: birthdate,
      status: Formz.validate([
        birthdate,
        state.displayName,
        state.firstName,
        state.lastName,
        state.gender,
        state.introduction,
        state.measurmentSystem,
        state.height,
      ]),
    );
  }

  Stream<CompleteAccountFormState> _mapFirstnameUpdatedToState(CompleteAccountFormFirstNameUpdated event) async* {
    final firstName = NameInput.dirty(event.value);

    yield state.copyWith(
        firstName: firstName,
        status: Formz.validate(
          [
            firstName,
            state.birthday,
            state.displayName,
            state.gender,
            state.introduction,
            state.lastName,
            state.measurmentSystem,
            state.height,
          ],
        ));
  }

  Stream<CompleteAccountFormState> _mapLastNameUpdatedToState(CompleteAccountFormLastNameUpdated event) async* {
    final lastName = NameInput.dirty(event.value);

    yield state.copyWith(
        lastName: lastName,
        status: Formz.validate(
          [
            lastName,
            state.birthday,
            state.displayName,
            state.firstName,
            state.gender,
            state.introduction,
            state.measurmentSystem,
            state.height,
          ],
        ));
  }

  Stream<CompleteAccountFormState> _mapGenderUpdatedToState(CompleteAccountFormGenderUpdated event) async* {
    if (event.value != null) {
      final gender = GenderInput.dirty(event.value!);
      yield state.copyWith(
        gender: gender,
        status: Formz.validate(
          [
            gender,
            state.birthday,
            state.displayName,
            state.firstName,
            state.introduction,
            state.lastName,
            state.measurmentSystem,
            state.height,
          ],
        ),
      );
    }
  }

  Stream<CompleteAccountFormState> _mapIntroductionUpdatedToState(CompleteAccountFormIntroductionUpdated event) async* {
    final introduction = IntroductionLineInput.dirty(event.value);
    yield state.copyWith(
        introduction: introduction,
        status: Formz.validate([
          introduction,
          state.birthday,
          state.displayName,
          state.firstName,
          state.gender,
          state.lastName,
          state.measurmentSystem,
          state.height,
        ]));
  }

  Stream<CompleteAccountFormState> _mapSubmitToState(CompleteAccountFormSubmit event) async* {
    if (_isAuth) {
      final introduction = IntroductionLineInput.dirty(state.introduction.value);
      final birthday = BirthdayInput.dirty(state.birthday.value);
      final lastName = NameInput.dirty(state.lastName.value);
      final firstName = NameInput.dirty(state.firstName.value);
      final displayName = NameInput.dirty(state.displayName.value);
      final gender = GenderInput.dirty(state.gender.value);
      final measurmentSystem = MeasurmentSystemInput.dirty(state.measurmentSystem.value);
      final height = HeightInput.dirty(state.height.value);

      yield state.copyWith(
        introduction: introduction,
        birthday: birthday,
        displayName: displayName,
        firstName: firstName,
        gender: gender,
        lastName: lastName,
        measurmentSystem: measurmentSystem,
        height: height,
        status: Formz.validate(
          [
            introduction,
            birthday,
            displayName,
            firstName,
            gender,
            lastName,
            measurmentSystem,
            height,
          ],
        ),
      );

      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        try {
          await _authenticationRepository.updatedUserData(state.user!);
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } catch (error) {
          yield state.copyWith(status: FormzStatus.submissionFailure);
        }
      }
    }
  }

  Stream<CompleteAccountFormState> _mapMeasurmentSystemUpdatedToState(CompleteAccountFormMeasurmentSystemUpdated event) async* {
    if (event.value != null) {
      final measurmentSystem = MeasurmentSystemInput.dirty(event.value!);

      yield state.copyWith(
          measurmentSystem: measurmentSystem,
          status: Formz.validate([
            measurmentSystem,
            state.birthday,
            state.displayName,
            state.firstName,
            state.gender,
            state.introduction,
            state.lastName,
            state.height,
          ]));
    }
  }

  Stream<CompleteAccountFormState> _mapHeightUpdatedToState(CompleteAccountFormHeightUpdated event) async* {
    if (event.value != null) {
      final height = HeightInput.dirty(event.value!);

      yield state.copyWith(
        height: height,
        status: Formz.validate(
          [
            height,
            state.birthday,
            state.displayName,
            state.firstName,
            state.gender,
            state.height,
            state.introduction,
            state.lastName,
            state.measurmentSystem,
          ],
        ),
      );
    }
  }
}
