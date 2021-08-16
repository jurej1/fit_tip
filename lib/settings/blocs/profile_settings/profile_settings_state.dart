part of 'profile_settings_bloc.dart';

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    this.user,
    required this.status,
  });

  final User? user;
  final AuthenticationStatus status;

  @override
  List<Object?> get props => [user, status];

  ProfileSettingsState copyWith({
    User? user,
    AuthenticationStatus? status,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
