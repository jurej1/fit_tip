part of 'add_workout_form_bloc.dart';

//TODO updating the active workout and updating the normal Workout

class AddWorkoutFormState {
  const AddWorkoutFormState({
    this.id,
    this.uid,
    this.status = FormzStatus.pure,
    this.goal = const WorkoutGoalFormz.pure(),
    this.type = const WorkoutTypeFormz.pure(),
    this.duration = const WorkoutIntFormz.pure(),
    this.daysPerWeek = const WorkoutIntFormz.pure(),
    this.timePerWorkout = const WorkoutIntFormz.pure(),
    this.note = const WorkoutNote.pure(),
    this.workoutDays = const WorkoutDaysList.pure(),
    required this.created,
    required this.formMode,
    this.title = const WorkoutTitle.pure(),
    this.isActive = false,
    this.public = const WorkoutPublicFormz.pure(), // TODO: this needs events ans bloc functions
  });

  final String? id;
  final String? uid;
  final WorkoutNote note;
  final FormzStatus status;
  final WorkoutGoalFormz goal;
  final WorkoutTypeFormz type;
  final WorkoutIntFormz duration;
  final WorkoutIntFormz daysPerWeek;
  final WorkoutIntFormz timePerWorkout; // TODO this field should be deleted
  final WorkoutDaysList workoutDays;
  final DateTime created;
  final FormMode formMode;
  final WorkoutTitle title;
  final bool isActive;
  final WorkoutPublicFormz public;

  factory AddWorkoutFormState.initial(
    Workout? workout,
    String userId,
  ) {
    if (workout == null) {
      return AddWorkoutFormState(
        created: DateTime.now(),
        formMode: FormMode.add,
        uid: userId,
      );
    }

    final daysPerWeek = WorkoutIntFormz.pure(workout.info.daysPerWeek.toStringAsFixed(0));

    return AddWorkoutFormState(
      uid: workout.info.uid,
      created: workout.info.created,
      daysPerWeek: daysPerWeek,
      duration: WorkoutIntFormz.pure(workout.info.duration.toStringAsFixed(0)),
      goal: WorkoutGoalFormz.pure(workout.info.goal),
      id: workout.info.id,
      note: WorkoutNote.pure(workout.info.note),
      timePerWorkout: WorkoutIntFormz.pure('null'), // TODO this field should be
      type: WorkoutTypeFormz.pure(workout.info.type),
      workoutDays: WorkoutDaysList.dirty(value: workout.workoutDays?.workoutDays ?? [], workoutsPerWeekend: daysPerWeek.getIntValue()),
      formMode: FormMode.edit,
      title: WorkoutTitle.pure(workout.info.title),
    );
  }

  AddWorkoutFormState copyWith({
    String? id,
    String? uid,
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
    WorkoutTitle? title,
    bool? isActive,
    WorkoutPublicFormz? public,
  }) {
    return AddWorkoutFormState(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      note: note ?? this.note,
      status: status ?? this.status,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      workoutDays: workoutDays ?? this.workoutDays,
      created: created ?? this.created,
      formMode: formMode ?? this.formMode,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
      public: public ?? this.public,
    );
  }

  Workout get workout {
    return Workout(
      info: WorkoutInfo(
        daysPerWeek: this.daysPerWeek.getIntValue(),
        id: this.id ?? '',
        title: this.title.value,
        uid: this.uid ?? '',
        created: DateTime.now(),
        duration: this.duration.getIntValue(),
        goal: this.goal.value,
        isPublic: this.public.value,
        note: this.note.value,
        type: this.type.value,
      ),
      workoutDays: WorkoutDays(
        workoutId: this.id ?? '',
        workoutDays: this.workoutDays.value,
      ),
    );
  }

  int get workoutDaysLenght => this.workoutDays.value.length;
  List<WorkoutDay> get workoutDaysItems => this.workoutDays.value;
  bool get noDaysPerWeek => this.daysPerWeek.pure || this.daysPerWeek.invalid || this.daysPerWeek.getIntValue() == 0;
}
