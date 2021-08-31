part of 'focused_workout_day_bloc.dart';

abstract class FocusedWorkoutDayState extends Equatable {
  const FocusedWorkoutDayState();

  @override
  List<Object?> get props => [];

  factory FocusedWorkoutDayState.initial(TableCalendarBloc tableCalendarBloc) {
    return FocusedWorkoutDayLoading();
  }
}

class FocusedWorkoutDayLoading extends FocusedWorkoutDayState {}

class FocusedWorkoutDayLoadSuccess extends FocusedWorkoutDayState {
  final WorkoutDay? workoutDay;
  final List<WorkoutDayLog> workoutDayLog;
  final DateTime date;
  final bool isWorkoutCompleted;

  const FocusedWorkoutDayLoadSuccess({
    required this.date,
    this.workoutDay,
    this.workoutDayLog = const [],
    this.isWorkoutCompleted = false,
  });
  @override
  List<Object?> get props => [workoutDay, date, workoutDayLog, isWorkoutCompleted];
}

class FocusedWorkoutDayFail extends FocusedWorkoutDayState {}
