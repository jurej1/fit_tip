part of 'workout_delete_cubit.dart';

abstract class WorkoutDeleteState extends Equatable {
  const WorkoutDeleteState(this.canDelete);

  final bool canDelete;

  @override
  List<Object> get props => [];
}

class WorkoutDeleteInitial extends WorkoutDeleteState {
  WorkoutDeleteInitial(bool canDelete) : super(canDelete);
}

class WorkoutDeleteLoading extends WorkoutDeleteState {
  WorkoutDeleteLoading(bool canDelete) : super(canDelete);
}

class WorkoutDeleteLoadSuccess extends WorkoutDeleteState {
  WorkoutDeleteLoadSuccess(bool canDelete) : super(canDelete);
}

class WorkoutDeleteFail extends WorkoutDeleteState {
  WorkoutDeleteFail(bool canDelete) : super(canDelete);
}
