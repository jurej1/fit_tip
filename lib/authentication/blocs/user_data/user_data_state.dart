part of 'user_data_bloc.dart';

class UserDataState extends Equatable {
  final User? user;
  const UserDataState(this.user);

  @override
  List<Object?> get props => [user];

  UserDataState copyWith({
    User? user,
  }) {
    return UserDataState(
      user ?? this.user,
    );
  }
}
