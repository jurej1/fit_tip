part of 'workout_excercise_card_bloc.dart';

class WorkoutExcerciseCardState extends Equatable {
  const WorkoutExcerciseCardState(this.excercise, this.isExpanded);

  final WorkoutExcercise excercise;
  final bool isExpanded;

  @override
  List<Object> get props => [excercise, isExpanded];

  WorkoutExcerciseCardState copyWith({
    WorkoutExcercise? excercise,
    bool? isExpanded,
  }) {
    return WorkoutExcerciseCardState(
      excercise ?? this.excercise,
      isExpanded ?? this.isExpanded,
    );
  }
}
