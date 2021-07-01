part of 'add_excercise_log_bloc.dart';

abstract class AddExcerciseLogEvent extends Equatable {
  const AddExcerciseLogEvent();

  @override
  List<Object> get props => [];
}

class AddExcerciseLogDurationUpdated extends AddExcerciseLogEvent {
  final double offset;

  const AddExcerciseLogDurationUpdated(this.offset);
  @override
  List<Object> get props => [offset];
}
