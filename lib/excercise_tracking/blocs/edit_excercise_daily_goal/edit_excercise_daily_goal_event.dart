part of 'edit_excercise_daily_goal_bloc.dart';

abstract class EditExcerciseDailyGoalEvent extends Equatable {
  const EditExcerciseDailyGoalEvent();

  @override
  List<Object> get props => [];
}

class EditExcerciseDailyGoalCaloriesBurnedPerWeekUpdated extends EditExcerciseDailyGoalEvent {
  final String value;

  const EditExcerciseDailyGoalCaloriesBurnedPerWeekUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class EditExcerciseDailyGoalWorkoutsPerWeekUpdated extends EditExcerciseDailyGoalEvent {
  final String value;

  const EditExcerciseDailyGoalWorkoutsPerWeekUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class EditExcerciseDailyGoalMinutesPerWorkoutUpdated extends EditExcerciseDailyGoalEvent {
  final String value;

  const EditExcerciseDailyGoalMinutesPerWorkoutUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class EditExcerciseDailyGoalMinutesPerDayUpdated extends EditExcerciseDailyGoalEvent {
  final String value;

  const EditExcerciseDailyGoalMinutesPerDayUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class EditExcerciseDailyGoalFormSubmited extends ExcerciseDailyGoalEvent {}
