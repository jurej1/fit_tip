part of 'workout_day_card_bloc.dart';

class WorkoutDayCardState extends Equatable {
  const WorkoutDayCardState({
    required this.workoutDay,
    this.isExpanded = false,
  });

  final WorkoutDay workoutDay;
  final bool isExpanded;

  @override
  List<Object> get props => [workoutDay, isExpanded];

  WorkoutDayCardState copyWith({
    WorkoutDay? workoutDay,
    bool? isExpanded,
  }) {
    return WorkoutDayCardState(
      workoutDay: workoutDay ?? this.workoutDay,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  double get iconSize => 18;
  BorderRadius get borderRadius => BorderRadius.circular(12);
}
