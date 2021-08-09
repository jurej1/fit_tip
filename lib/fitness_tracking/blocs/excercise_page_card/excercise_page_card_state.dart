part of 'excercise_page_card_bloc.dart';

class ExcercisePageCardState extends Equatable {
  const ExcercisePageCardState({
    required this.excercise,
    required this.repsCount,
    required this.weightCount,
  });

  final WorkoutExcercise excercise;
  final List<int> repsCount;
  final List<double> weightCount;

  factory ExcercisePageCardState.pure(WorkoutExcercise workoutExcercise) {
    final amountOfSets = workoutExcercise.sets;

    if (amountOfSets == 0) {
      return ExcercisePageCardState(
        excercise: workoutExcercise,
        repsCount: [],
        weightCount: [],
      );
    }
    return ExcercisePageCardState(
      excercise: workoutExcercise,
      repsCount: List<int>.generate(amountOfSets, (index) => 0),
      weightCount: List<double>.generate(amountOfSets, (index) => 50.0),
    );
  }

  ExcercisePageCardState copyWith({
    WorkoutExcercise? excercise,
    List<int>? repsCount,
    List<double>? weightCount,
  }) {
    return ExcercisePageCardState(
      excercise: excercise ?? this.excercise,
      repsCount: repsCount ?? this.repsCount,
      weightCount: weightCount ?? this.weightCount,
    );
  }

  @override
  List<Object> get props => [excercise, repsCount, weightCount];

  WorkoutExcercise getNewWorkoutExcercise() {
    return this.excercise.copyWith(
          repCount: repsCount,
          weightCount: weightCount,
        );
  }
}
