part of 'excercise_page_card_bloc.dart';

class ExcercisePageCardState extends Equatable {
  const ExcercisePageCardState({
    required this.excercise,
  });

  final WorkoutExcercise excercise;

  @override
  List<Object> get props => [excercise];

  ExcercisePageCardState copyWith({
    WorkoutExcercise? excercise,
  }) {
    return ExcercisePageCardState(
      excercise: excercise ?? this.excercise,
    );
  }
}
