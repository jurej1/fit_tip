part of 'add_excercise_log_bloc.dart';

abstract class AddExcerciseLogEvent extends Equatable {
  const AddExcerciseLogEvent();

  @override
  List<Object?> get props => [];
}

class AddExcerciseLogDurationUpdated extends AddExcerciseLogEvent {
  final int value;

  const AddExcerciseLogDurationUpdated([this.value = 0]);
  @override
  List<Object> get props => [value];
}

class AddExcerciseLogNameUpdated extends AddExcerciseLogEvent {
  final String value;

  const AddExcerciseLogNameUpdated(this.value);
  @override
  List<Object> get props => [value];
}

class AddExcerciseLogIntensityUpdated extends AddExcerciseLogEvent {
  final Intensity? value;

  const AddExcerciseLogIntensityUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class AddExcerciseLogCaloriesUpdated extends AddExcerciseLogEvent {
  final String value;
  const AddExcerciseLogCaloriesUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class AddExcerciseLogTimeUpdated extends AddExcerciseLogEvent {
  final TimeOfDay? value;

  const AddExcerciseLogTimeUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class AddExcerciseLogDateUpdated extends AddExcerciseLogEvent {
  final DateTime? value;

  const AddExcerciseLogDateUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class AddExcerciseLogFormSubmit extends AddExcerciseLogEvent {}
