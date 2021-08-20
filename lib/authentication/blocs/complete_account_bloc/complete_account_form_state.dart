part of 'complete_account_form_bloc.dart';

class CompleteAccountFormState extends Equatable {
  const CompleteAccountFormState({
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.displayName = const NameInput.pure(),
    this.gender = const GenderInput.pure(),
    this.birthday = const BirthdayInput.pure(),
    this.introduction = const IntroductionLineInput.pure(),
    this.status = FormzStatus.pure,
  });

  final NameInput firstName;
  final NameInput lastName;
  final NameInput displayName;
  final GenderInput gender;
  final BirthdayInput birthday;
  final IntroductionLineInput introduction;
  final FormzStatus status;

  @override
  List<Object> get props {
    return [
      firstName,
      lastName,
      displayName,
      gender,
      birthday,
      introduction,
      status,
    ];
  }

  CompleteAccountFormState copyWith({
    NameInput? firstName,
    NameInput? lastName,
    NameInput? displayName,
    GenderInput? gender,
    BirthdayInput? birthdayInput,
    IntroductionLineInput? introduction,
    FormzStatus? status,
  }) {
    return CompleteAccountFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      birthday: birthdayInput ?? this.birthday,
      introduction: introduction ?? this.introduction,
      status: status ?? this.status,
    );
  }

  factory CompleteAccountFormState.initial(AuthenticationBloc authenticationBloc) {
    if (authenticationBloc.state.status.isAuthenticated && authenticationBloc.state.user != null) {
      final User user = authenticationBloc.state.user!;
      return CompleteAccountFormState(
        birthday: BirthdayInput.pure(user.birthdate),
        displayName: NameInput.pure(user.displayName ?? ''),
        firstName: NameInput.pure(user.firstName ?? ''),
        gender: GenderInput.pure(user.gender),
        introduction: IntroductionLineInput.pure(user.introduction ?? ''),
        lastName: NameInput.pure(user.lastName ?? ''),
      );
    }
    return CompleteAccountFormState();
  }
}
