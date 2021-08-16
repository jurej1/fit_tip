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
