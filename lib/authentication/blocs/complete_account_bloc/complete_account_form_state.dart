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
    this.user,
    this.measurmentSystem = const MeasurmentSystemInput.pure(),
    this.height = const HeightInput.pure(),
  });

  final NameInput firstName;
  final NameInput lastName;
  final NameInput displayName;
  final GenderInput gender;
  final BirthdayInput birthday;
  final IntroductionLineInput introduction;
  final FormzStatus status;
  final User? user;
  final MeasurmentSystemInput measurmentSystem;
  final HeightInput height;

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      displayName,
      gender,
      birthday,
      introduction,
      status,
      user,
      measurmentSystem,
      height,
    ];
  }

  CompleteAccountFormState copyWith({
    NameInput? firstName,
    NameInput? lastName,
    NameInput? displayName,
    GenderInput? gender,
    BirthdayInput? birthday,
    IntroductionLineInput? introduction,
    FormzStatus? status,
    User? user,
    MeasurmentSystemInput? measurmentSystem,
    HeightInput? height,
  }) {
    return CompleteAccountFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      introduction: introduction ?? this.introduction,
      status: status ?? this.status,
      user: user ?? this.user,
      measurmentSystem: measurmentSystem ?? this.measurmentSystem,
      height: height ?? this.height,
    );
  }

  factory CompleteAccountFormState.initial(User? user) {
    if (user != null) {
      return CompleteAccountFormState(
        birthday: BirthdayInput.pure(user.birthdate),
        displayName: NameInput.pure(user.displayName ?? ''),
        firstName: NameInput.pure(user.firstName ?? ''),
        gender: GenderInput.pure(user.gender),
        introduction: IntroductionLineInput.pure(user.introduction ?? ''),
        lastName: NameInput.pure(user.lastName ?? ''),
        user: user,
        measurmentSystem: MeasurmentSystemInput.pure(user.measurmentSystem),
        height: HeightInput.pure(user.height ?? 0),
      );
    }
    return CompleteAccountFormState();
  }

  User? getNewUser() {
    return this.user?.copyWith(
          birthdate: birthday.value,
          displayName: displayName.value,
          firstName: firstName.value,
          gender: gender.value,
          introduction: introduction.value,
          lastName: lastName.value,
          measurmentSystem: measurmentSystem.value,
          height: height.value,
        );
  }
}
