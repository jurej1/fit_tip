part of 'add_excercise_log_bloc.dart';

class AddExcerciseLogState extends Equatable {
  final ExcerciseDuration duration;
  final FormzStatus status;
  final ExcerciseName name;
  final ExcerciseIntensity intensity;
  final ExcerciseCalories calories;
  final ExcerciseStartTime time;
  final ExcerciseStartDate date;
  final ExcerciseTypeInput type;

  final ExcerciseLog? excerciseLog;
  final FormMode mode;

  const AddExcerciseLogState({
    this.duration = const ExcerciseDuration.pure(),
    this.status = FormzStatus.pure,
    this.name = const ExcerciseName.pure(),
    this.intensity = const ExcerciseIntensity.pure(),
    this.calories = const ExcerciseCalories.pure(),
    required this.time,
    required this.date,
    this.excerciseLog,
    this.type = const ExcerciseTypeInput.pure(),
    this.mode = FormMode.add,
  });

  factory AddExcerciseLogState.initial() {
    return AddExcerciseLogState(
      time: ExcerciseStartTime.pure(),
      date: ExcerciseStartDate.pure(),
    );
  }

  factory AddExcerciseLogState.edit(ExcerciseLog log) {
    return AddExcerciseLogState(
      time: ExcerciseStartTime.pure(TimeOfDay(hour: log.startTime.hour, minute: log.startTime.minute)),
      date: ExcerciseStartDate.pure(log.startTime),
      calories: ExcerciseCalories.pure(log.calories.toStringAsFixed(0)),
      duration: ExcerciseDuration.pure(log.duration),
      excerciseLog: log,
      intensity: ExcerciseIntensity.pure(log.intensity),
      mode: FormMode.edit,
      name: ExcerciseName.pure(log.name),
      type: ExcerciseTypeInput.pure(log.type),
    );
  }

  @override
  List<Object?> get props {
    return [
      duration,
      status,
      name,
      intensity,
      calories,
      time,
      date,
      type,
      excerciseLog,
      mode,
    ];
  }

  AddExcerciseLogState copyWith({
    ExcerciseDuration? duration,
    FormzStatus? status,
    ExcerciseName? name,
    ExcerciseIntensity? intensity,
    ExcerciseCalories? calories,
    ExcerciseStartTime? time,
    ExcerciseStartDate? date,
    ExcerciseTypeInput? type,
    ExcerciseLog? excerciseLog,
    FormMode? mode,
  }) {
    return AddExcerciseLogState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
      name: name ?? this.name,
      intensity: intensity ?? this.intensity,
      calories: calories ?? this.calories,
      time: time ?? this.time,
      date: date ?? this.date,
      type: type ?? this.type,
      excerciseLog: excerciseLog ?? this.excerciseLog,
      mode: mode ?? this.mode,
    );
  }
}
