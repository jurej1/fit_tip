part of 'profile_settings_bloc.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

class _ProfileSettingsUserUpdated extends ProfileSettingsEvent {
  final User? user;

  const _ProfileSettingsUserUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

class _ProfileSettingsUserFail extends ProfileSettingsEvent {}

class ProfileSettingsEditButtonPressed extends ProfileSettingsEvent {}

class ProfileSettingsBirthdayUpdated extends ProfileSettingsEvent {
  final DateTime? value;

  const ProfileSettingsBirthdayUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileSettingsDisplayNameUpdated extends ProfileSettingsEvent {
  final String value;

  const ProfileSettingsDisplayNameUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class ProfileSettingsGenderUpdated extends ProfileSettingsEvent {
  final Gender? value;

  const ProfileSettingsGenderUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class ProfileSettingsHeightUpdated extends ProfileSettingsEvent {
  final double? value;

  const ProfileSettingsHeightUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class ProfileSettingsIntroductionLineUpdated extends ProfileSettingsEvent {
  final String value;

  const ProfileSettingsIntroductionLineUpdated(this.value);

  @override
  List<Object?> get props => [value];
}
