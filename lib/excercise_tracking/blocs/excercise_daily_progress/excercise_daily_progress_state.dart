part of 'excercise_daily_progress_bloc.dart';

abstract class ExcerciseDailyProgressState extends Equatable {
  const ExcerciseDailyProgressState();

  @override
  List<Object> get props => [];
}

class ExcerciseDailyProgressLoading extends ExcerciseDailyProgressState {}

class ExcerciseDailyProgressLoadSuccess extends ExcerciseDailyProgressState {
  final ExcerciseDailyGoal goal;

  final int minutesWorkout;
  final int caloriesBurned;
  final int avgMinutesPerWorkout;

  ExcerciseDailyProgressLoadSuccess({
    required this.goal,
    List<ExcerciseLog> excercises = const [],
  })  : this.minutesWorkout = excercises.fold(0, (p, e) => p + e.duration),
        this.caloriesBurned = excercises.fold(0, (p, e) => p + e.calories),
        this.avgMinutesPerWorkout = excercises.fold<int>(0, (p, e) => p + e.duration) ~/ excercises.length;
}

class ExcerciseDailyProgressFailure extends ExcerciseDailyProgressState {
  final String errorMsg;

  const ExcerciseDailyProgressFailure(this.errorMsg);
}
