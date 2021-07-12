part of 'add_workout_day_form_bloc.dart';

class AddWorkoutDayFormState extends Equatable {
  const AddWorkoutDayFormState({
    required this.id,
    required this.day,
    this.note = const WorkoutNote.pure(),
    this.muscleGroupList = const WorkoutMuscleGroupList.pure(),
    this.workoutExcercisesList = const WorkoutExcercisesList.pure(),
    this.status = FormzStatus.pure,
  });

  final String id;
  final int day;
  final WorkoutNote note;
  final WorkoutMuscleGroupList muscleGroupList;
  final WorkoutExcercisesList workoutExcercisesList;
  final FormzStatus status;

  factory AddWorkoutDayFormState.initial(WorkoutDay workoutDay) {
    return AddWorkoutDayFormState(
      id: workoutDay.id,
      day: workoutDay.day,
      muscleGroupList: WorkoutMuscleGroupList.pure(workoutDay.musclesTargeted),
      note: WorkoutNote.pure(workoutDay.note),
      workoutExcercisesList: WorkoutExcercisesList.pure(workoutDay.excercises),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      day,
      note,
      muscleGroupList,
      workoutExcercisesList,
      status,
    ];
  }

  AddWorkoutDayFormState copyWith({
    String? id,
    int? day,
    WorkoutNote? note,
    WorkoutMuscleGroupList? muscleGroupList,
    WorkoutExcercisesList? workoutExcercisesList,
    FormzStatus? status,
  }) {
    return AddWorkoutDayFormState(
      id: id ?? this.id,
      day: day ?? this.day,
      note: note ?? this.note,
      muscleGroupList: muscleGroupList ?? this.muscleGroupList,
      workoutExcercisesList: workoutExcercisesList ?? this.workoutExcercisesList,
      status: status ?? this.status,
    );
  }
}
