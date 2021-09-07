part of 'active_workout_id_bloc.dart';

abstract class ActiveWorkoutIdEvent extends Equatable {
  const ActiveWorkoutIdEvent();

  @override
  List<Object?> get props => [];
}

class ActiveWorkoutIdUpdated extends ActiveWorkoutIdEvent {
  final String? id;

  const ActiveWorkoutIdUpdated(this.id);

  @override
  List<Object?> get props => [id];
}
