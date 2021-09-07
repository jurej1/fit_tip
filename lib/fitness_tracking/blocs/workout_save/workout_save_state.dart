part of 'workout_save_cubit.dart';

abstract class WorkoutSaveState extends Equatable {
  const WorkoutSaveState(this.isSaved);

  final bool isSaved;

  @override
  List<Object> get props => [isSaved];
}

class WorkoutSaveInitial extends WorkoutSaveState {
  const WorkoutSaveInitial(bool isSaved) : super(isSaved);
}

class WorkoutSaveLoading extends WorkoutSaveState {
  const WorkoutSaveLoading(bool isSaved) : super(isSaved);
}

class WorkoutSaveLoadSuccess extends WorkoutSaveState {
  const WorkoutSaveLoadSuccess(bool isSaved) : super(isSaved);
}

class WorkoutsSaveFail extends WorkoutSaveState {
  const WorkoutsSaveFail(bool isSaved) : super(isSaved);
}
