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
  final WorkoutDayDay day;
  final WorkoutNote note;
  final WorkoutMuscleGroupList muscleGroupList;
  final WorkoutExcercisesList workoutExcercisesList;
  final FormzStatus status;

  factory AddWorkoutDayFormState.initial(WorkoutDay workoutDay) {
    return AddWorkoutDayFormState(
      id: workoutDay.id,
      day: WorkoutDayDay.pure(workoutDay.day),
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
    WorkoutDayDay? day,
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

  String mapDayToText(int index) {
    return DateFormat('EEEE').format(DateTime(0, 0, index));
  }

  List<MuscleGroup> getMuscleGroupList() {
    return this.muscleGroupList.value ?? [];
  }

  List<MuscleGroup> getAvailableMuscleGroups() {
    List<MuscleGroup> allGroups = List.from(MuscleGroup.values);

    if (this.muscleGroupList.value == null) return allGroups;

    return allGroups..removeWhere((element) => !this.muscleGroupList.value!.contains(element));
  }
}
