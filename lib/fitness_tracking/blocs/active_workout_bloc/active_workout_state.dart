part of 'active_workout_bloc.dart';

abstract class ActiveWorkoutState extends Equatable {
  const ActiveWorkoutState();

  @override
  List<Object> get props => [];
}

class ActiveWorkoutLoading extends ActiveWorkoutState {}

class ActiveWorkoutLoadSuccess extends ActiveWorkoutState {
  final Workout workout;

  const ActiveWorkoutLoadSuccess(this.workout);

  @override
  List<Object> get props => [workout];

  List<int> getEvents(DateTime day) {
    final int length = workout.workouts.fold<int>(0, (previousValue, element) {
      if (element.day == day.weekday) {
        return previousValue + 1;
      }
      return previousValue;
    });

    return List.generate(length, (index) => index);
  }
}

class ActiveWorkoutFail extends ActiveWorkoutState {}

class ActiveWorkoutNone extends ActiveWorkoutState {}
