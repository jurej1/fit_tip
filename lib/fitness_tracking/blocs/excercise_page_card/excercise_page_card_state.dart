part of 'excercise_page_card_bloc.dart';

class ExcercisePageCardState {
  const ExcercisePageCardState({
    required this.excercise,
    required this.repsCount,
    required this.weightCount,
  });

  final WorkoutExcercise excercise;
  final List<int> repsCount;
  final List<int> weightCount;

  factory ExcercisePageCardState.pure(WorkoutExcercise workoutExcercise) {
    final amountOfSets = workoutExcercise.sets;
    return ExcercisePageCardState(
      excercise: workoutExcercise,
      repsCount: List.generate(amountOfSets, (index) => 0),
      weightCount: List.generate(amountOfSets, (index) => 50),
    );
  }

  ExcercisePageCardState copyWith({
    WorkoutExcercise? excercise,
    List<int>? repsCount,
    List<int>? weightCount,
  }) {
    return ExcercisePageCardState(
      excercise: excercise ?? this.excercise,
      repsCount: repsCount ?? this.repsCount,
      weightCount: weightCount ?? this.weightCount,
    );
  }
}
