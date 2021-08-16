part of 'profile_settings_bloc.dart';

enum ProfileSettingsMode { look, edit }

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({this.user, required this.status, required this.mode});

  final User? user;
  final AuthenticationStatus status;
  final ProfileSettingsMode mode;

  @override
  List<Object?> get props => [user, status, mode];

  ProfileSettingsState copyWith({
    User? user,
    AuthenticationStatus? status,
    ProfileSettingsMode? mode,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      status: status ?? this.status,
      mode: mode ?? this.mode,
    );
  }
}
