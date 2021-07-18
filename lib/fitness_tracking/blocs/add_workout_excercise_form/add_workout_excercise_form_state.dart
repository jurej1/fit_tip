part of 'add_workout_excercise_form_bloc.dart';

class AddWorkoutExcerciseFormState extends Equatable {
  AddWorkoutExcerciseFormState({
    this.name = const WorkoutExcerciseName.pure(),
    this.sets = const WorkoutExcerciseIntFormz.pure(),
    this.reps = const WorkoutExcerciseIntFormz.pure(),
    this.repUnit = const WorkoutRepUnit.pure(),
    this.status = FormzStatus.pure,
    String? id,
  }) : this.id = id ?? UniqueKey().toString();

  final WorkoutExcerciseName name;
  final WorkoutExcerciseIntFormz sets;
  final WorkoutExcerciseIntFormz reps;
  final WorkoutRepUnit repUnit;
  final FormzStatus status;
  final String id;

  @override
  List<Object> get props {
    return [
      name,
      sets,
      reps,
      repUnit,
      status,
      id,
    ];
  }

  factory AddWorkoutExcerciseFormState.initial([WorkoutExcercise? excercise]) {
    if (excercise == null) {
      return AddWorkoutExcerciseFormState();
    }

    return AddWorkoutExcerciseFormState(
      id: excercise.id,
      name: WorkoutExcerciseName.pure(excercise.name),
      repUnit: WorkoutRepUnit.dirty(excercise.repUnit),
      reps: WorkoutExcerciseIntFormz.dirty(excercise.reps),
      sets: WorkoutExcerciseIntFormz.dirty(excercise.sets),
    );
  }

  WorkoutExcercise get excercise {
    return WorkoutExcercise(
      id: id,
      name: name.value,
      repUnit: repUnit.value,
      reps: reps.value,
      sets: sets.value,
    );
  }

  AddWorkoutExcerciseFormState copyWith({
    WorkoutExcerciseName? name,
    WorkoutExcerciseIntFormz? sets,
    WorkoutExcerciseIntFormz? reps,
    WorkoutRepUnit? repUnit,
    FormzStatus? status,
    String? id,
  }) {
    return AddWorkoutExcerciseFormState(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      repUnit: repUnit ?? this.repUnit,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}
