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
  });

  factory AddExcerciseLogState.initial() {
    return AddExcerciseLogState(
      time: ExcerciseStartTime.pure(),
      date: ExcerciseStartDate.pure(),
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
    );
  }
}
