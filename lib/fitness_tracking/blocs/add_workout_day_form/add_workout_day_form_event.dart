part of 'add_workout_day_form_bloc.dart';

abstract class AddWorkoutDayFormEvent extends Equatable {
  const AddWorkoutDayFormEvent();

  @override
  List<Object?> get props => [];
}

class AddWorkoutDayDayChanged extends AddWorkoutDayFormEvent {
  final int? value;

  const AddWorkoutDayDayChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutDayNoteChanged extends AddWorkoutDayFormEvent {
  final String value;

  const AddWorkoutDayNoteChanged(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutDayMuscleGroupAdded extends AddWorkoutDayFormEvent {
  final MuscleGroup? value;

  const AddWorkoutDayMuscleGroupAdded(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutDayMuscleGroupRemoved extends AddWorkoutDayFormEvent {
  final MuscleGroup value;

  const AddWorkoutDayMuscleGroupRemoved(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutDayExcerciseAdded extends AddWorkoutDayFormEvent {
  final WorkoutExcercise value;

  const AddWorkoutDayExcerciseAdded(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutDayExcerciseRemoved extends AddWorkoutDayFormEvent {
  final WorkoutExcercise value;

  const AddWorkoutDayExcerciseRemoved(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutDayExcerciseUpdated extends AddWorkoutDayFormEvent {
  final WorkoutExcercise value;

  const AddWorkoutDayExcerciseUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutDayFormSubmited extends AddWorkoutDayFormEvent {}
