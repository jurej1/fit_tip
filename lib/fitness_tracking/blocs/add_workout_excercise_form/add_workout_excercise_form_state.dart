part of 'add_workout_excercise_form_bloc.dart';

class AddWorkoutExcerciseFormState extends Equatable {
  const AddWorkoutExcerciseFormState({
    this.name = const WorkoutExcerciseName.pure(),
    this.sets = const WorkoutExcerciseIntFormz.pure(),
    this.reps = const WorkoutExcerciseIntFormz.pure(),
    this.repUnit = const WorkoutRepUnit.pure(),
    this.status = FormzStatus.pure,
  });

  final WorkoutExcerciseName name;
  final WorkoutExcerciseIntFormz sets;
  final WorkoutExcerciseIntFormz reps;
  final WorkoutRepUnit repUnit;
  final FormzStatus status;

  @override
  List<Object> get props {
    return [
      name,
      sets,
      reps,
      repUnit,
      status,
    ];
  }

  AddWorkoutExcerciseFormState copyWith({
    WorkoutExcerciseName? name,
    WorkoutExcerciseIntFormz? sets,
    WorkoutExcerciseIntFormz? reps,
    WorkoutRepUnit? repUnit,
    FormzStatus? status,
  }) {
    return AddWorkoutExcerciseFormState(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      repUnit: repUnit ?? this.repUnit,
      status: status ?? this.status,
    );
  }
}
