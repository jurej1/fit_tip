part of 'add_workout_day_form_bloc.dart';

class AddWorkoutDayFormState {
  const AddWorkoutDayFormState({
    required this.id,
    required this.day,
    this.note = const WorkoutDayNote.pure(),
    this.muscleGroupList = const WorkoutMuscleGroupList.pure(),
    this.workoutExcercisesList = const WorkoutExcercisesList.pure(),
    this.status = FormzStatus.pure,
  });

  final String id;
  final WorkoutDayDay day;
  final WorkoutDayNote note;
  final WorkoutMuscleGroupList muscleGroupList;
  final WorkoutExcercisesList workoutExcercisesList;
  final FormzStatus status;

  WorkoutDay get workoutDay {
    return WorkoutDay(
      id: id,
      day: day.value,
      excercises: getExcercisesList(),
      musclesTargeted: getMuscleGroupList(),
      note: note.value,
    );
  }

  factory AddWorkoutDayFormState.initial(WorkoutDay workoutDay) {
    return AddWorkoutDayFormState(
      id: workoutDay.id,
      day: WorkoutDayDay.pure(workoutDay.day),
      muscleGroupList: WorkoutMuscleGroupList.pure(workoutDay.musclesTargeted),
      note: WorkoutDayNote.pure(workoutDay.note),
      workoutExcercisesList: WorkoutExcercisesList.pure(workoutDay.excercises),
    );
  }

  AddWorkoutDayFormState copyWith({
    String? id,
    WorkoutDayDay? day,
    WorkoutDayNote? note,
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

  List<MuscleGroup> getMuscleGroupList() {
    return this.muscleGroupList.value ?? [];
  }

  List<MuscleGroup> getAvailableMuscleGroups() {
    List<MuscleGroup> allGroups = List.from(MuscleGroup.values);

    if (this.muscleGroupList.value == null) return allGroups;

    return allGroups..removeWhere((element) => this.muscleGroupList.value!.contains(element));
  }

  List<WorkoutExcercise> getExcercisesList() {
    return this.workoutExcercisesList.value;
  }
}
