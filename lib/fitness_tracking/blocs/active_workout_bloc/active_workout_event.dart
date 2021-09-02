part of 'active_workout_bloc.dart';

abstract class ActiveWorkoutEvent extends Equatable {
  const ActiveWorkoutEvent();

  @override
  List<Object?> get props => [];
}

class ActiveWorkoutLoadRequested extends ActiveWorkoutEvent {
  final String? id;

  const ActiveWorkoutLoadRequested(this.id);

  @override
  List<Object?> get props => [id];
}
