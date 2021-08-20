import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/settings/models/birthday_input.dart';
import 'package:fit_tip/settings/models/gender_input.dart';
import 'package:fit_tip/settings/models/introduction_line_input.dart';
import 'package:formz/formz.dart';

part 'complete_account_form_event.dart';
part 'complete_account_form_state.dart';

class CompleteAccountFormBloc extends Bloc<CompleteAccountFormEvent, CompleteAccountFormState> {
  CompleteAccountFormBloc({
    required AuthenticationBloc authenticationBloc,
  }) : super(CompleteAccountFormState.initial(authenticationBloc));

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
      ]),
    );
  }

  Stream<CompleteAccountFormState> _mapBirthdateUpdatedToState(CompleteAccountFormBirthdateUpdated event) async* {
    final birthdate = BirthdayInput.dirty(event.value);

    yield state.copyWith(
      birthdayInput: birthdate,
      status: Formz.validate([
        birthdate,
        state.displayName,
        state.firstName,
        state.lastName,
        state.gender,
        state.introduction,
      ]),
    );
  }

  Stream<CompleteAccountFormState> _mapFirstnameUpdatedToState(CompleteAccountFormFirstNameUpdated event) async* {
    final firstName = NameInput.dirty(event.value);

    yield state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          firstName,
          state.birthday,
          state.displayName,
          state.gender,
          state.introduction,
          state.lastName,
        ]));
  }

  Stream<CompleteAccountFormState> _mapLastNameUpdatedToState(CompleteAccountFormLastNameUpdated event) async* {
    final lastName = NameInput.dirty(event.value);

    yield state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          lastName,
          state.birthday,
          state.displayName,
          state.firstName,
          state.gender,
          state.introduction,
        ]));
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
        ]));
  }
}
