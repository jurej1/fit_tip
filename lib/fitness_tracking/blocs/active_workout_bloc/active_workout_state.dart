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
}

class ActiveWorkoutFail extends ActiveWorkoutState {}

class ActiveWorkoutNone extends ActiveWorkoutState {}
