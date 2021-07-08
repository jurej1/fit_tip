part of 'excercise_daily_progress_bloc.dart';

enum ExcerciseDailyProgressView {
  minutesWorkout,
  caloriesBurned,
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

  final int minutesPerDay;
  final int caloriesBurnedPerDay;
  final int avgMinutesPerWorkout;

  final ExcerciseDailyProgressView view;

  const ExcerciseDailyProgressLoadSuccess({
    required this.goal,
    required this.minutesPerDay,
    required this.caloriesBurnedPerDay,
    required this.avgMinutesPerWorkout,
    this.view = ExcerciseDailyProgressView.minutesWorkout,
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
      minutesPerDay: minutesWorkout ?? this.minutesPerDay,
      caloriesBurnedPerDay: caloriesBurned ?? this.caloriesBurnedPerDay,
      avgMinutesPerWorkout: avgMinutesPerWorkout ?? this.avgMinutesPerWorkout,
      view: view ?? this.view,
    );
  }

  @override
  List<Object> get props => [goal, minutesPerDay, caloriesBurnedPerDay, avgMinutesPerWorkout, view];

  int getPrimaryValue() {
    if (this.view == ExcerciseDailyProgressView.avgMinutesPerWorkout) {
      return this.avgMinutesPerWorkout;
    } else if (this.view == ExcerciseDailyProgressView.minutesWorkout) {
      return this.minutesPerDay;
    } else {
      return this.caloriesBurnedPerDay;
    }
  }

  int getMaxValue() {
    if (this.view == ExcerciseDailyProgressView.avgMinutesPerWorkout) {
      return goal.minutesPerWorkout;
    } else if (this.view == ExcerciseDailyProgressView.minutesWorkout) {
      return goal.minutesPerDay;
    } else {
      return goal.caloriesBurnedPerDay;
    }
  }

  Color getPrimaryColor() {
    if (this.view == ExcerciseDailyProgressView.minutesWorkout) {
      return Colors.red;
    } else if (this.view == ExcerciseDailyProgressView.caloriesBurned) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  Color getSecondaryColor() {
    return getPrimaryColor().withOpacity(0.35);
  }

  double getIndexOfView() {
    return ExcerciseDailyProgressView.values.indexOf(view).toDouble();
  }
}

class ExcerciseDailyProgressFailure extends ExcerciseDailyProgressState {
  final String errorMsg;

  const ExcerciseDailyProgressFailure(this.errorMsg);
}
