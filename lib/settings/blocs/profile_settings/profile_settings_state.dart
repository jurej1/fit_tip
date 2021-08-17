part of 'profile_settings_bloc.dart';

enum ProfileSettingsMode { look, edit }

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    this.user,
    required this.authenticationStatus,
    this.mode = ProfileSettingsMode.look,
    this.birthday = const BirthdayInput.pure(),
    this.displayName = const DisplayNameInput.pure(),
    this.gender = const GenderInput.pure(),
    this.height = const HeightInput.pure(),
    this.introductionLine = const IntroductionLineInput.pure(),
    this.status = FormzStatus.pure,
  });

  final User? user;
  final AuthenticationStatus authenticationStatus;
  final ProfileSettingsMode mode;
  final BirthdayInput birthday;
  final DisplayNameInput displayName;
  final GenderInput gender;
  final HeightInput height;
  final IntroductionLineInput introductionLine;
  final FormzStatus status;

  @override
  List<Object?> get props {
    return [
      user,
      mode,
      birthday,
      displayName,
      gender,
      height,
      introductionLine,
      status,
    ];
  }

  factory ProfileSettingsState.fromUser(User? user) {
    if (user == null) {
      return ProfileSettingsState(authenticationStatus: AuthenticationStatus.unknown);
    }

    return ProfileSettingsState(
      authenticationStatus: AuthenticationStatus.authenticated,
      user: user,
      birthday: BirthdayInput.pure(user.birthdate),
      displayName: DisplayNameInput.pure(user.displayName),
      gender: GenderInput.pure(user.gender ?? Gender.unknown),
      height: HeightInput.pure(user.height?.toString() ?? ''),
      introductionLine: IntroductionLineInput.pure(user.introduction ?? ''),
    );
  }

  ProfileSettingsState copyWith({
    User? user,
    AuthenticationStatus? authenticationStatus,
    ProfileSettingsMode? mode,
    BirthdayInput? birthday,
    DisplayNameInput? displayName,
    GenderInput? gender,
    HeightInput? height,
    IntroductionLineInput? introductionLine,
    FormzStatus? status,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      mode: mode ?? this.mode,
      birthday: birthday ?? this.birthday,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      introductionLine: introductionLine ?? this.introductionLine,
      status: status ?? this.status,
    );
  }

  bool get isEditMode => mode == ProfileSettingsMode.edit;
}
