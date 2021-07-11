part of 'workouts_days_list_bloc.dart';

class WorkoutsDaysListState extends Equatable {
  const WorkoutsDaysListState({
    this.status = FormzStatus.pure,
    this.workoutDays = const WorkoutDaysList.pure(),
  });

  final FormzStatus status;
  final WorkoutDaysList workoutDays;
  @override
  List<Object> get props => [status, workoutDays];

  int get itemsLength => workoutDays.value.length;
  List<WorkoutDay> get items => workoutDays.value;

  WorkoutsDaysListState copyWith({
    FormzStatus? status,
    WorkoutDaysList? workoutDays,
  }) {
    return WorkoutsDaysListState(
      status: status ?? this.status,
      workoutDays: workoutDays ?? this.workoutDays,
    );
  }
}
