part of 'add_workout_form_bloc.dart';

class AddWorkoutFormState {
  const AddWorkoutFormState({
    this.id,
    this.status = FormzStatus.pure,
    this.goal = const WorkoutGoalFormz.pure(),
    this.type = const WorkoutTypeFormz.pure(),
    this.duration = const WorkoutIntFormz.pure(),
    this.daysPerWeek = const WorkoutIntFormz.pure(),
    this.timePerWorkout = const WorkoutIntFormz.pure(),
    required this.startDate,
    this.note = const WorkoutNote.pure(),
    this.workoutDays = const WorkoutDaysList.pure(),
    required this.created,
    required this.formMode,
  });

  final String? id;
  final WorkoutNote note;
  final FormzStatus status;
  final WorkoutGoalFormz goal;
  final WorkoutTypeFormz type;
  final WorkoutIntFormz duration;
  final WorkoutIntFormz daysPerWeek;
  final WorkoutIntFormz timePerWorkout;
  final WorkoutDateFormz startDate;
  final WorkoutDaysList workoutDays;
  final DateTime created;
  final FormMode formMode;

  factory AddWorkoutFormState.initial(Workout? workout) {
    if (workout == null) {
      return AddWorkoutFormState(
        startDate: WorkoutDateFormz.pure(),
        created: DateTime.now(),
        formMode: FormMode.add,
      );
    }

    final daysPerWeek = WorkoutIntFormz.pure(workout.daysPerWeek.toStringAsFixed(0));

    return AddWorkoutFormState(
      startDate: WorkoutDateFormz.pure(workout.startDate),
      created: workout.created,
      daysPerWeek: daysPerWeek,
      duration: WorkoutIntFormz.pure(workout.duration.toStringAsFixed(0)),
      goal: WorkoutGoalFormz.pure(workout.goal),
      id: workout.id,
      note: WorkoutNote.pure(workout.note),
      timePerWorkout: WorkoutIntFormz.pure(workout.timePerWorkout.toStringAsFixed(0)),
      type: WorkoutTypeFormz.pure(workout.type),
      workoutDays: WorkoutDaysList.dirty(value: workout.workouts, workoutsPerWeekend: daysPerWeek.getIntValue()),
      formMode: FormMode.edit,
    );
  }

  AddWorkoutFormState copyWith({
    String? id,
    WorkoutNote? note,
    FormzStatus? status,
    WorkoutGoalFormz? goal,
    WorkoutTypeFormz? type,
    WorkoutIntFormz? duration,
    WorkoutIntFormz? daysPerWeek,
    WorkoutIntFormz? timePerWorkout,
    WorkoutDateFormz? startDate,
    WorkoutDaysList? workoutDays,
    DateTime? created,
    FormMode? formMode,
  }) {
    return AddWorkoutFormState(
      id: id ?? this.id,
      note: note ?? this.note,
      status: status ?? this.status,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
      workoutDays: workoutDays ?? this.workoutDays,
      created: created ?? this.created,
      formMode: formMode ?? this.formMode,
    );
  }

  Workout get workout {
    return Workout(
      note: this.note.value,
      id: id ?? UniqueKey().toString(),
      goal: this.goal.value,
      type: this.type.value,
      duration: this.duration.getIntValue(),
      daysPerWeek: this.daysPerWeek.getIntValue(),
      timePerWorkout: this.timePerWorkout.getIntValue(),
      startDate: this.startDate.value,
      workouts: this.workoutDays.value,
      created: created,
    );
  }

  int get workoutDaysLenght => this.workoutDays.value.length;
  List<WorkoutDay> get workoutDaysItems => this.workoutDays.value;
  bool get noDaysPerWeek => this.daysPerWeek.pure || this.daysPerWeek.invalid || this.daysPerWeek.getIntValue() == 0;
}
