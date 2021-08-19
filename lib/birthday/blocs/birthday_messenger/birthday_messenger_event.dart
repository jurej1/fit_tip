part of 'birthday_messenger_bloc.dart';

abstract class BirthdayMessengerEvent extends Equatable {
  const BirthdayMessengerEvent();

  @override
  List<Object?> get props => [];
}

class _BirthdayMessengerUserUpdated extends BirthdayMessengerEvent {
  final User? user;

  const _BirthdayMessengerUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
