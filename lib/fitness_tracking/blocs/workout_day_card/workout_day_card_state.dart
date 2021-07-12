part of 'workout_day_card_bloc.dart';

class WorkoutDayCardState extends Equatable {
  const WorkoutDayCardState(
    this.workoutDay,
  );

  final WorkoutDay workoutDay;

  @override
  List<Object> get props => [workoutDay];

  WorkoutDayCardState copyWith({
    WorkoutDay? workoutDay,
  }) {
    return WorkoutDayCardState(
      workoutDay ?? this.workoutDay,
    );
  }
}
