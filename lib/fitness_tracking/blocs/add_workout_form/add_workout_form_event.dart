part of 'add_workout_form_bloc.dart';

abstract class AddWorkoutFormEvent extends Equatable {
  const AddWorkoutFormEvent();

  @override
  List<Object?> get props => [];
}

class AddWorkoutFormGoalUpdated extends AddWorkoutFormEvent {
  final WorkoutGoal? value;

  const AddWorkoutFormGoalUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormTypeUpdated extends AddWorkoutFormEvent {
  final WorkoutType? value;

  const AddWorkoutFormTypeUpdated(this.value);
  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormDurationUpdated extends AddWorkoutFormEvent {
  final String value;

  const AddWorkoutFormDurationUpdated(this.value);
  @override
  List<Object> get props => [value];
}

class AddWorkoutFormDaysPerWeekUpdated extends AddWorkoutFormEvent {
  final String value;

  const AddWorkoutFormDaysPerWeekUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutFormTimePerWorkoutUpdated extends AddWorkoutFormEvent {
  final String value;

  const AddWorkoutFormTimePerWorkoutUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class AddWorkoutFormNoteUpdated extends AddWorkoutFormEvent {
  final String value;

  const AddWorkoutFormNoteUpdated(this.value);
  @override
  List<Object> get props => [value];
}

class AddWorkoutFormStartDateUpdated extends AddWorkoutFormEvent {
  final DateTime? value;

  const AddWorkoutFormStartDateUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormListItemAdded extends AddWorkoutFormEvent {
  final WorkoutDay value;

  const AddWorkoutFormListItemAdded(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormListItemRemoved extends AddWorkoutFormEvent {
  final WorkoutDay value;

  const AddWorkoutFormListItemRemoved(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormListItemUpdated extends AddWorkoutFormEvent {
  final WorkoutDay value;

  const AddWorkoutFormListItemUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWorkoutFormSubmitted extends AddWorkoutFormEvent {}
