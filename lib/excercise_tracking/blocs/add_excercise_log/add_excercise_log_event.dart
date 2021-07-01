part of 'add_excercise_log_bloc.dart';

abstract class AddExcerciseLogEvent extends Equatable {
  const AddExcerciseLogEvent();

  @override
  List<Object> get props => [];
}

class AddExcerciseLogDurationUpdated extends AddExcerciseLogEvent {
  final int value;

  const AddExcerciseLogDurationUpdated([this.value = 0]);
  @override
  List<Object> get props => [value];
}
