part of 'today_excercise_bloc.dart';

class TodayExcerciseState extends Equatable {
  const TodayExcerciseState({
    required this.workoutDay,
    required this.currentExcercise,
  });

  final WorkoutDay workoutDay;
  final WorkoutExcercise currentExcercise;

  @override
  List<Object> get props => [workoutDay, currentExcercise];

  TodayExcerciseState copyWith({
    WorkoutDay? workoutDay,
    WorkoutExcercise? currentExcercise,
  }) {
    return TodayExcerciseState(
      workoutDay: workoutDay ?? this.workoutDay,
      currentExcercise: currentExcercise ?? this.currentExcercise,
    );
  }
}
