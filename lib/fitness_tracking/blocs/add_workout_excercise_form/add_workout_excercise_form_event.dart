part of 'add_workout_excercise_form_bloc.dart';

abstract class AddWorkoutExcerciseFormEvent extends Equatable {
  const AddWorkoutExcerciseFormEvent();

  @override
  List<Object> get props => [];
}

class AddWorkoutExcerciseNameUpdated extends AddWorkoutExcerciseFormEvent {
  final String value;

  const AddWorkoutExcerciseNameUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutExcerciseSetsUpdated extends AddWorkoutExcerciseFormEvent {
  final int value;

  const AddWorkoutExcerciseSetsUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutExcerciseRepsUpdated extends AddWorkoutExcerciseFormEvent {
  final int value;

  const AddWorkoutExcerciseRepsUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutExcerciseRepUnitUpdated extends AddWorkoutExcerciseFormEvent {
  final RepUnit value;

  const AddWorkoutExcerciseRepUnitUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutExcerciseFormSubmitted extends AddWorkoutExcerciseFormEvent {}
