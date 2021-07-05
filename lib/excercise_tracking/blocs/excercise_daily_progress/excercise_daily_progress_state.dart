part of 'excercise_daily_progress_bloc.dart';

enum ExcerciseDailyProgressView {
  caloriesBurned,
  minutesPerWorkout,
  avgMinutesPerWorkout,
}

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

  final ExcerciseDailyProgressView view;

  const ExcerciseDailyProgressLoadSuccess({
    required this.goal,
    required this.minutesWorkout,
    required this.caloriesBurned,
    required this.avgMinutesPerWorkout,
    this.view = ExcerciseDailyProgressView.caloriesBurned,
  });

  ExcerciseDailyProgressLoadSuccess copyWith({
    ExcerciseDailyGoal? goal,
    int? minutesWorkout,
    int? caloriesBurned,
    int? avgMinutesPerWorkout,
    ExcerciseDailyProgressView? view,
  }) {
    return ExcerciseDailyProgressLoadSuccess(
      goal: goal ?? this.goal,
      minutesWorkout: minutesWorkout ?? this.minutesWorkout,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      avgMinutesPerWorkout: avgMinutesPerWorkout ?? this.avgMinutesPerWorkout,
      view: view ?? this.view,
    );
  }

  @override
  List<Object> get props => [goal, minutesWorkout, caloriesBurned, avgMinutesPerWorkout];

  int getPrimaryValue() {
    if (this.view == ExcerciseDailyProgressView.avgMinutesPerWorkout) {
      return this.avgMinutesPerWorkout;
    } else if (this.view == ExcerciseDailyProgressView.caloriesBurned) {
      return this.caloriesBurned;
    } else {
      return this.minutesWorkout;
    }
  }

  int getMaxValue() {
    if (this.view == ExcerciseDailyProgressView.avgMinutesPerWorkout) {
      return goal.minutesPerWorkout;
    } else if (this.view == ExcerciseDailyProgressView.caloriesBurned) {
      return goal.caloriesBurnedPerDay;
    } else {
      return goal.minutesPerDay;
    }
  }
}

class ExcerciseDailyProgressFailure extends ExcerciseDailyProgressState {
  final String errorMsg;

  const ExcerciseDailyProgressFailure(this.errorMsg);
}
