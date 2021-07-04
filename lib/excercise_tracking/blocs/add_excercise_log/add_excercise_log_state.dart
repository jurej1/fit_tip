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

  final FormMode mode;
  final String id;

  const AddExcerciseLogState({
    this.duration = const ExcerciseDuration.pure(),
    this.status = FormzStatus.pure,
    this.name = const ExcerciseName.pure(),
    this.intensity = const ExcerciseIntensity.pure(),
    this.calories = const ExcerciseCalories.pure(),
    required this.time,
    required this.date,
    this.type = const ExcerciseTypeInput.pure(),
    this.mode = FormMode.add,
    this.id = '',
  });

  factory AddExcerciseLogState.initial(DateTime date) {
    return AddExcerciseLogState(
      time: ExcerciseStartTime.pure(),
      date: ExcerciseStartDate.pure(date),
    );
  }

  factory AddExcerciseLogState.edit(ExcerciseLog log) {
    return AddExcerciseLogState(
      time: ExcerciseStartTime.pure(TimeOfDay(hour: log.startTime.hour, minute: log.startTime.minute)),
      date: ExcerciseStartDate.pure(log.startTime),
      calories: ExcerciseCalories.pure(log.calories.toStringAsFixed(0)),
      duration: ExcerciseDuration.pure(log.duration),
      intensity: ExcerciseIntensity.pure(log.intensity),
      mode: FormMode.edit,
      name: ExcerciseName.pure(log.name),
      type: ExcerciseTypeInput.pure(log.type),
      id: log.id,
    );
  }

  @override
  List<Object> get props {
    return [
      duration,
      status,
      name,
      intensity,
      calories,
      time,
      date,
      type,
      mode,
      id,
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
    FormMode? mode,
    String? id,
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
      mode: mode ?? this.mode,
      id: id ?? this.id,
    );
  }

  ExcerciseLog get excerciseLog {
    final newDate = date.value;
    final newTime = time.value;
    return ExcerciseLog(
      name: this.name.value,
      duration: duration.value,
      intensity: intensity.value,
      calories: int.parse(calories.value),
      startTime: DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        newTime.hour,
        newTime.minute,
      ),
      type: type.value,
    );
  }
}
